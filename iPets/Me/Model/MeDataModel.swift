//
//  SettingDataModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MeDataModel{
    
    var pic: UIImage?
    var icon: String?
    var name: String?
    var nickname: String?
    var lable: String?
    var TDicon: String?
    var height: CGFloat

    init(pic: UIImage?, name: String?, nickname: String?, lable: String?, TDicon: String?, icon: String?, height: CGFloat){
        self.pic = pic   //个人设置栏的个人头像
        self.name = name //个人设置栏的个人名字
        self.nickname = nickname  //个人设置栏的个人昵称
        self.lable = lable  //普通设置栏的名称
        self.TDicon = TDicon //个人设置栏二维码图片
        self.icon = icon //普通设置栏的图片
        self.height = height    //高度
    }
    
    //个人设置栏
    convenience init(pic: UIImage, name: String, nickname: String, TDicon: String){
        let pic = pic
        let name = name
        let nickname = nickname
        let TDicon = TDicon
        let height = CGFloat(100)
        
        self.init(pic: pic, name: name, nickname: nickname, lable: nil, TDicon: TDicon, icon: nil, height: height)
    }
    
    //普通设置栏
    convenience init(icon: String, lable: String){
        let lable = lable
        let icon = icon
        let height = CGFloat(44)
        
        self.init(pic: nil, name: nil, nickname: nil, lable: lable, TDicon: nil, icon: icon, height: height)
    }
    
}
