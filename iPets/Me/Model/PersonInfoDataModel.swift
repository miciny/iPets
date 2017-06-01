//
//  PersonInfoModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class PersonInfoDataModel: NSObject {
    
    var name: String
    var pic: UIImage?
    var lable: String?
    var TDicon: String?
    var height: CGFloat
    
    init(pic: UIImage?, name: String, lable: String?, TDicon: String?, height: CGFloat){
        self.pic = pic  //个人设置栏的头像
        self.name = name  //设置栏的前头的名称
        self.lable = lable //设置栏后面的名称，如果有的话
        self.TDicon = TDicon //设置栏的二维码
        self.height = height
    }
    
    //头像栏
    convenience init(pic: UIImage, name: String){
        let pic = pic
        let name = name
        self.init(pic: pic, name: name, lable: nil, TDicon: nil, height: 100)
    }
    
    //二维码栏
    convenience init(TDicon: String, name: String){
        let name = name
        let TDicon = TDicon
        self.init(pic: nil, name: name, lable: nil, TDicon: TDicon, height: 44)
    }
    
    //其他lable栏
    convenience init(lable: String, name: String){
        let name = name
        let lable = lable
        self.init(pic: nil, name: name, lable: lable, TDicon: nil, height: 44)
    }
}
