//
//  ContectorModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

/*
 联系人
 */

class ContectorModel: NSObject {
    var name: String
    var sex: String
    var nickname: String
    var icon: UIImage
    var remark: String
    var address: String
    var http: String
    
    init(name: String, sex: String, nickname: String, icon: UIImage, remark: String, address: String, http: String){
        self.name = name
        self.sex = sex
        self.nickname = nickname
        self.icon = icon
        self.remark = remark
        self.address = address
        self.http = http
        super.init()
    }
}
