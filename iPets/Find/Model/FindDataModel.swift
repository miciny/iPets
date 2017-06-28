//
//  FindDataMaodel.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/9.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class FindDataModel: NSObject {
    
    var icon: String
    var title: String
    
    var leftIcon: UIImage?
    var height: CGFloat
    
    init(title: String, icon: String, leftIcon: UIImage?,height: CGFloat){
        self.title = title      //
        self.icon = icon        //
        self.height = height    //高度
        self.leftIcon = leftIcon
    }
    
    //普通设置栏
    convenience init(icon: String, title: String){
        self.init(title: title, icon: icon, leftIcon: nil, height: 44)
    }
    
    convenience init(icon: String, title: String, leftIcon: UIImage?){
        self.init(title: title, icon: icon, leftIcon: leftIcon, height: 44)
    }
    
}
