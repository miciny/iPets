//
//  SettingDataModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SettingDataModel{
    var pic: UIImage
    var icon: String
    var name: String
    var nickname: String
    var lable: String
    var TDicon: String
    var view: UIView

    init(pic: UIImage, name: String, nickname: String, lable: String, TDicon: String, icon: String, view: UIView){
        self.pic = pic   //个人设置栏的个人头像
        self.name = name //个人设置栏的个人名字
        self.nickname = nickname  //个人设置栏的个人昵称
        self.lable = lable  //普通设置栏的名称
        self.TDicon = TDicon //个人设置栏二维码图片
        self.icon = icon //普通设置栏的图片
        self.view = view
    }
    
    //个人设置栏
    convenience init(pic: UIImage, name: String, nickname: String, TDicon: String){
        let pic = pic
        let name = name
        let icon = ""
        let nickname = nickname
        let TDicon = TDicon
        let lable = ""
        
        //个人设置栏
        let mainSettingView = UIView()
        mainSettingView.frame = CGRect(x: 0, y: 20, width: Width, height: 100)
        
        self.init(pic: pic, name: name, nickname: nickname, lable: lable, TDicon: TDicon, icon: icon, view: mainSettingView)
    }
    
    //普通设置栏
    convenience init(icon: String, lable: String){
        let pic = UIImage()
        let name = ""
        let nickname = ""
        let TDicon = ""
        let lable = lable
        let icon = icon
        
        //普通设置栏
        let mainSettingView = UIView()
        mainSettingView.frame = CGRect(x: 0, y: 20, width: Width, height: 44)
        
        self.init(pic: pic, name: name, nickname: nickname, lable: lable, TDicon: TDicon, icon: icon, view: mainSettingView)
    }
    
}
