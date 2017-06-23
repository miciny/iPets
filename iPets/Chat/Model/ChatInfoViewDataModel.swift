//
//  ChatInfoViewDataModel.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class ChatInfoViewDataModel: NSObject {
    
    var icon: UIImage?
    var name: String?
    var nickname: String?
    
    var label: String?
    var isSwitch: Bool?
    
    var height: CGFloat
    
    init(icon: UIImage?, name: String?, nickname: String?, label: String?, isSwitch: Bool?, height: CGFloat){
        self.icon = icon
        self.name = name
        self.nickname = nickname
        self.label = label
        self.isSwitch = isSwitch
        self.height = height
        
        super.init()
    }
    
    convenience init(icon: UIImage, name: String, nickname: String){
        self.init(icon: icon, name: name, nickname: nickname, label: nil, isSwitch: nil, height: 100)
    }
    
    convenience init(label: String, isSwitch: Bool){
        self.init(icon: nil, name: nil, nickname: nil, label: label, isSwitch: isSwitch, height: 44)
    }
    
    convenience init(label: String){
        self.init(icon: nil, name: nil, nickname: nil, label: label, isSwitch: nil, height: 44)
    }
}
