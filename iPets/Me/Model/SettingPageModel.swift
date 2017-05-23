//
//  SettingPageModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SettingPageModel: NSObject {
    var name: String
    var pic: UIImage?
    var lable: String?
    var view: UIView
    
    init(pic: UIImage?, name: String, lable: String?, view: UIView){
        self.pic = pic  //设置页的帐号
        self.name = name  //设置页的title
        self.lable = lable //设置页的文字，如果有的话
        self.view = view
    }
    
    convenience init(pic: UIImage?, name: String, lable: String?){
        let pic = pic
        let name = name
        let lable = lable
        
        let mainInfoView = UIView(frame: CGRect(x: 0, y: 20, width: Width, height: 44))
        
        self.init(pic: pic, name: name, lable: lable, view: mainInfoView)
    }

}
