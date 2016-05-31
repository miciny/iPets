//
//  SendFindMyPetInfoModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/30.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SendFindMyPetInfoModel: NSObject {
    var pics: [UIImage]
    var icon: String
    var name: String
    var lable: String
    var view: UIView
    
    init(pics: [UIImage], name: String, lable: String, icon: String, view: UIView){
        self.pics = pics
        self.name = name //
        self.lable = lable  //
        self.icon = icon //
        
        self.view = view
    }
    
    //普通栏
    convenience init(name: String, lable: String, icon: String){
        let pics = [UIImage]()
        let name = name
        let icon = icon
        let lable = lable
        
        //个人设置栏
        let mainInfoView = UIView()
        mainInfoView.frame = CGRect(x: 0, y: 20, width: Width, height: 44)
        
        self.init(pics: pics, name: name, lable: lable, icon: icon, view: mainInfoView)
    }
    
    //输入栏
    convenience init(pics: [UIImage]){
        let pics = pics
        let name = ""
        let icon = ""
        let lable = ""
        let mainInfoView = UIView()
        
        if pics.count <= 3 {
            mainInfoView.frame = CGRect(x: 0, y: 0, width: Width, height: 200)
        }else if pics.count <= 7{
            mainInfoView.frame = CGRect(x: 0, y: 0, width: Width, height: 300)
        }else{
            mainInfoView.frame = CGRect(x: 0, y: 0, width: Width, height: 400)
        }
        
        self.init(pics: pics, name: name, lable: lable, icon: icon, view: mainInfoView)
    }
}
