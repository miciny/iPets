//
//  GuestContectorInfoModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/28.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ContectorInfoViewDataModel: NSObject {
    
    var icon: UIImage?
    var name: String?
    var nickname: String?
    var remark: String?
    var address: String?
    var sex: String?
    var http: String?
    var height: CGFloat
    
    init(icon: UIImage?, name: String?, nickname: String?, remark: String?, address: String?, sex: String?, http: String?, height: CGFloat){
        self.icon = icon   //头像
        self.name = name //名字
        self.nickname = nickname  //昵称
        self.remark = remark  //
        self.address = address //
        self.sex = sex //
        self.http = http
        self.height = height
    }
    
    //个人头像栏
    convenience init(icon: UIImage, name: String, nickname: String, sex: String){
        let icon = icon
        let name = name
        let nickname = nickname
        let sex = sex
        
        self.init(icon: icon, name: name, nickname: nickname, remark: nil, address: nil, sex: sex, http: nil, height: 100)
    }
    
    //标签栏
    convenience init(remark: String){
        let remark = remark
        
        self.init(icon: nil, name: nil, nickname: nil, remark: remark, address: nil, sex: nil, http: nil, height: 44)
    }
    
    //个人相册栏
    convenience init(http: String){
        let http = http
        
        self.init(icon: nil, name: nil, nickname: nil, remark: nil, address: nil, sex: nil, http: http, height: 90)
    }
    
    //地区栏
    convenience init(address: String){
        let address = address
        
        self.init(icon: nil, name: nil, nickname: nil, remark: nil, address: address, sex: nil, http: nil, height: 44)
    }

}
