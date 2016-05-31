//
//  PersonInfoModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class PersonInfoModel: NSObject {
    
    var name: String
    var pic: UIImage
    var lable: String
    var TDicon: String
    var view: UIView
    
    init(pic: UIImage, name: String, lable: String, TDicon: String, view: UIView){
        self.pic = pic  //个人设置栏的头像
        self.name = name  //设置栏的前头的名称
        self.lable = lable //设置栏后面的名称，如果有的话
        self.TDicon = TDicon //设置栏的二维码
        self.view = view
    
    }
    
    //头像栏
    convenience init(pic: UIImage, name: String){
        let pic = pic
        let name = name
        let TDicon = ""
        let lable = ""
        
        let mainInfoView = UIView(frame: CGRect(x: 0, y: 20, width: Width, height: 100))
        
        self.init(pic: pic, name: name, lable: lable, TDicon: TDicon, view: mainInfoView)
    }
    
    //二维码栏
    convenience init(TDicon: String, name: String){
        let pic = UIImage()
        let name = name
        let TDicon = TDicon
        let lable = ""
        
        let mainInfoView = UIView(frame: CGRect(x: 0, y: 20, width: Width, height: 44))
        
        self.init(pic: pic, name: name, lable: lable, TDicon: TDicon, view: mainInfoView)
    }
    
    //其他lable栏
    convenience init(lable: String, name: String){
        let pic = UIImage()
        let name = name
        let TDicon = ""
        let lable = lable
        
        let mainInfoView = UIView(frame: CGRect(x: 0, y: 20, width: Width, height: 44))
        
        self.init(pic: pic, name: name, lable: lable, TDicon: TDicon, view: mainInfoView)
    }
}
