//
//  SettingPageModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SettingDataModel: NSObject {
    var name: String
    var pic: UIImage?
    var lable: String?
    var height: CGFloat
    
    init(pic: UIImage?, name: String, lable: String?, height: CGFloat){
        self.pic = pic  //设置页的帐号
        self.name = name  //设置页的title
        self.lable = lable //设置页的文字，如果有的话
        self.height = height
    }
    
    convenience init(pic: UIImage?, name: String, lable: String?){
        let pic = pic
        let name = name
        let lable = lable
        
        self.init(pic: pic, name: name, lable: lable, height: 44)
    }

}
