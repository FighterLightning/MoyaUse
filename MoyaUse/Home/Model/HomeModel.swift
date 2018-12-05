//
//  HotRecommendModel.swift
//  MoyaDemo
//
//  Created by 张海峰 on 2018/12/3.
//  Copyright © 2018年 张海峰. All rights reserved.
//

import UIKit
import ObjectMapper
struct HomeModel:  Mappable{
    var citys :NSString? //城市id 拼接字符串
    var id :NSInteger = 0 //
    var name :String? //
    var cover_pic :String? //
    var pic :String? //
    var price :String? //
    var interests :String? //
    var pic_height :CGFloat = 0 //
    var pic_width :CGFloat = 0 //
    var is_lightcolor : NSInteger = 0 //1 浅（字体黑色） 2 深（字体白色）
    var x: CGFloat = 0
    var y: CGFloat = 0
    mutating func mapping(map: Map) {
        citys    <- map["citys"]
        id    <- map["id"]
        name    <- map["name"]
        cover_pic    <- map["cover_pic"]
        pic    <- map["pic"]
        price    <- map["price"]
        interests    <- map["interests"]
        pic_height    <- map["pic_height"]
        pic_width    <- map["pic_width"]
        is_lightcolor    <- map["is_lightcolor"]
        x    <- map["x"]
        y    <- map["y"]
    }
    init?(map: Map) {
    }
}
