//
//  HomeVC.swift
//  test
//
//  Created by 张海峰 on 2018/12/5.
//  Copyright © 2018年 张海峰. All rights reserved.
//

import UIKit
import Chrysan
class HomeVC: UIViewController {
    lazy var dataMarr:NSMutableArray = NSMutableArray()
    var homeView: HomeView = HomeView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "首页"
        setUI()
        loadData(page: 1)
    }
}

//设置UI
extension HomeVC{
    func setUI(){
        self.view.addSubview(homeView.initView())
    }
}
//网络请求

extension  HomeVC{
    //基本数据请求和模型转换
    func loadData(page:NSInteger){
        let timestamp:String = NSString.initNowDate()
        let  Arr :[String] = ["page=\(page)",
            "timestamp=\(timestamp)",
            "user_id=7",
            //"case=123",
        ]
        let parameters = NSString.initMd5(Arr: Arr) //把数组加密之后生成需要传给后台的字典
        ZHFNetwork.request(target: .HaveParameters(pathStr: getBoxRecommendUrl, parameters: parameters), success: { (result) in
            let dic = result as! NSDictionary
            let code : NSInteger = dic["code"] as! NSInteger
            if code == 200{
                let Arr : NSArray = dic["data"] as! NSArray
                if Arr.count > 0{
                    for i in 0 ..< Arr.count{
                        let dic1 : [String : Any] = Arr[i] as! [String : Any]
                        let homeModel:HomeModel = HomeModel(JSON: dic1)!
                        self.dataMarr.add(homeModel)
                    }
                    //刷新表格数据
                    DispatchQueue.main.async{
                        self.homeView.arr = self.dataMarr
                    
                       // self.chrysan.showPlainMessage("请求成功,刷新列表", hideDelay: 2)
                    }
                }
                else{
                    self.chrysan.showPlainMessage("请求成功，无更多数据", hideDelay: 2)
                }
            }
            else{
                //请求成功，没有找到对应数据(常见问题传参错误，传参加密问题，后台定义的code)
                self.chrysan.showPlainMessage("\(dic["msg"]!)code=\(code)", hideDelay: 2)
            }
        }, error1: { (statusCode) in
            //服务器报错等问题 (常见问题404 ，地址错误)
            self.chrysan.showPlainMessage("请求错误！错误码：\(statusCode)", hideDelay: 2)
        }) { (error) in
            //没有网络等问题 （网络超时，没有网）
            self.chrysan.showPlainMessage("请求失败！错误信息：\(error.errorDescription!)", hideDelay: 2)
        }
  }
}
