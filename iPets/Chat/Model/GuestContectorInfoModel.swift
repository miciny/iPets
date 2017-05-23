//
//  GuestContectorInfoModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/28.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class GuestContectorInfoModel: NSObject {
    
    var icon: UIImage
    var name: String
    var nickname: String
    var remark: String
    var address: String
    var sex: String
    var http: String
    var view: UIView
    
    init(icon: UIImage, name: String, nickname: String, remark: String, address: String, sex: String, http: String, view: UIView){
        self.icon = icon   //头像
        self.name = name //名字
        self.nickname = nickname  //昵称
        self.remark = remark  //
        self.address = address //
        self.sex = sex //
        self.http = http
        self.view = view
    }
    
    //个人头像栏
    convenience init(icon: UIImage, name: String, nickname: String, sex: String){
        let icon = icon
        let name = name
        let nickname = nickname
        let sex = sex
        
        let address = ""
        let remark = ""
        let http = ""
        
        //个人设置栏
        let view = UIView()
        view.frame = CGRect(x: 0, y: 20, width: Width, height: 100)
        
        self.init(icon: icon, name: name, nickname: nickname, remark: remark, address: address, sex: sex, http: http, view: view)
    }
    
    //标签栏
    convenience init(remark: String){
        let icon = UIImage()
        let name = ""
        let nickname = ""
        let sex = ""
        let address = ""
        let http = ""
        let remark = remark
        
        //普通设置栏
        let view = UIView()
        view.frame = CGRect(x: 0, y: 20, width: Width, height: 44)
        
        self.init(icon: icon, name: name, nickname: nickname, remark: remark, address: address, sex: sex, http: http, view: view)
    }
    
    //个人相册栏
    convenience init(http: String){
        let icon = UIImage()
        let name = ""
        let nickname = ""
        let sex = ""
        let address = ""
        let http = http
        let remark = ""
        
        //普通设置栏
        let view = UIView()
        view.frame = CGRect(x: 0, y: 20, width: Width, height: 90)
        
        self.init(icon: icon, name: name, nickname: nickname, remark: remark, address: address, sex: sex, http: http, view: view)
    }
    
    //地区栏
    convenience init(address: String){
        let icon = UIImage()
        let name = ""
        let nickname = ""
        let sex = ""
        let address = address
        let http = ""
        let remark = ""
        
        //普通设置栏
        let view = UIView()
        view.frame = CGRect(x: 0, y: 20, width: Width, height: 44)
        
        self.init(icon: icon, name: name, nickname: nickname, remark: remark, address: address, sex: sex, http: http, view: view)
    }

}
