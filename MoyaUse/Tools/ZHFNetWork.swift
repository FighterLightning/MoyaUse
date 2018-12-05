//
//  ZHFNetWork.swift
//  MoyaDemo
//
//  Created by 张海峰 on 2018/12/3.
//  Copyright © 2018年 张海峰. All rights reserved.
//
import Foundation
import Moya
//网络请求
struct ZHFNetwork {
    // 请求成功的回调
    typealias successCallback = (_ result: Any) -> Void
    //上传进度
    typealias progressCallback = (_ progress: Double) -> Void
    // 请求错误的回调
    typealias errorCallback = (_ statusCode: Int) -> Void
    // 请求失败的回调
    typealias failureCallback = (_ error: MoyaError) -> Void
    //NetworkActivityPlugin 管理网络状态的插件
//    let networkPlugin = NetworkActivityPlugin{ (type,_)  in
//        switch type{
//        case .began:
//            print("显示loading")
//        case .ended:
//            NSLog("隐藏loading")
//        }
//    }
    // 单例
    static let provider = MoyaProvider<ZHFService>(plugins: [NetworkActivityPlugin{ (type,_)  in
        switch type{
        case .began:
            print("显示loading")
        case .ended:
            NSLog("隐藏loading")
        }
        }])
    // 发送网络请求
    static func request(
        target: ZHFService,
        success: @escaping successCallback,
        error1: @escaping errorCallback,
        failure: @escaping failureCallback
        ) {
        provider.request(target) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    //如果数据返回成功则直接将结果转为JSON
                    try success(moyaResponse.mapJSON())
                } catch let error{
                    //服务器报错等问题 (常见问题404 ，地址错误)
                    error1((error as! MoyaError).response!.statusCode)
                }
            case let .failure(error):
                //没有网络等问题 （网络超时，没有网）（必要时还可以将尝试重新发起请求）
                failure(error)
            }
        }
    }
    //上传文件
    static func upload(
        target: ZHFService,
        progress:@escaping  progressCallback,
        success: @escaping successCallback,
        error1: @escaping errorCallback,
        failure: @escaping failureCallback){
        provider.request(target, callbackQueue: nil, progress: { (ProgressResponse) in
            progress(ProgressResponse.progress)
        }) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    //如果数据返回成功则直接将结果转为JSON
                    try success(moyaResponse.mapJSON())
                } catch let error{
                    //服务器报错等问题 (常见问题404 ，地址错误)
                    error1((error as! MoyaError).response!.statusCode)
                }
            case let .failure(error):
                //没有网络等问题 （网络超时，没有网）（必要时还可以将尝试重新发起请求）
                failure(error)
            }
        }
    }
}
// 定义请求方法
enum ZHFService {
    //没有参数
    case NoParameters(pathStr:String)
    //有参数
    case HaveParameters(pathStr:String,parameters: [String : Any])
    //上传头像图片
    case uploadPortraitImage(pathStr:String,parameters: [String : Any],imageData: Data)
    //上传文件
    case uploadFileURL(pathStr:String,parameters: [String : Any],fileURL: URL)
    //多文件上传
//    case uploadFiles(pathStr:String,parameters: [String : Any],value1: String, value2: Int, file1Data:Data, file2URL:URL)

}
extension ZHFService: TargetType {
    // 请求服务器的根路径
    var baseURL: URL {return URL.init(string: BASE_SERVER_URL)!}
    
    // 每个API对应的具体路径
    var path: String {
        switch self {
        case .NoParameters(let pathStr):
            return pathStr
        case .HaveParameters(let pathStr, _):
            return pathStr
        case .uploadPortraitImage(let pathStr, _, _):
            return pathStr
        case .uploadFileURL(let pathStr, _, _):
            return pathStr
        }
    }
    
    // 各个接口的请求方式，get或post
    var method: Moya.Method {
        switch self {
        case .NoParameters:
            return .get
        case .HaveParameters:
            return .post
        case .uploadPortraitImage:
            return .post
        case .uploadFileURL:
            return .post
        }
    }
    // 请求是否携带参数，
    var task: Task {
        switch self {
        case .NoParameters:
            return .requestPlain // 无参数
        case .HaveParameters(_,let parameters): // 带有参数,注意前面的let
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        //上传头像
        case .uploadPortraitImage(_, _,let imageData):
            print(imageData)
            let formData = MultipartFormData.init(provider: MultipartFormData.FormDataProvider.data(imageData), name: "pic", fileName: "pic.png", mimeType: "image/png")
             print(formData)
              let multipartData = [formData]
            return .uploadMultipart(multipartData)
        case .uploadFileURL(_, _, let fileURL):
             return .uploadFile(fileURL)
        }
    }
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    var sampleData: Data {
        switch self {
        case .NoParameters:
            return "just for test".utf8Encoded
        case .HaveParameters(let parameters):
            return "{\"parameters\": \(parameters)\"}".utf8Encoded
        case .uploadPortraitImage(_,let parameters, _):
            return "{\"parameters\": \(parameters)\"}".utf8Encoded
        case .uploadFileURL(_,let parameters, _):
            return "{\"parameters\": \(parameters)\"}".utf8Encoded
        }
    }
    // 请求头
    var headers: [String : String]? {
        switch self {
        case .NoParameters:
             return ["Content-type" : "application/x-www-form-urlencoded"]
        case .HaveParameters(_):
            return ["Content-type" : "application/x-www-form-urlencoded"]
        case .uploadPortraitImage(_,_ , _):
            return ["Content-type" : "multipart/form-data"]
        case .uploadFileURL(_,_, _):
            return ["Content-type" : "multipart/form-data"]
        //"Content-type" : "application/json",
        //"Content-type" : "text/html",
        //"Content-type" : "text/plain",
        //"Content-type" : "text/javascript"
        //"Content-type" : "multipart/form-data" 上传表单
        }
    }
}
// 扩展方法
private extension String {
    var utf8Encoded: Data {
        return data(using: String.Encoding.utf8)!
    }
}


