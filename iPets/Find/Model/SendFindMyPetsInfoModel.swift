//
//  SendFindMyPetInfoModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/30.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SendFindMyPetsInfoModel: NSObject {
    var pics: [UIImage]?
    var icon: String?
    var name: String?
    var lable: String?
    var height: CGFloat
    
    init(pics: [UIImage]?, name: String?, lable: String?, icon: String?, height: CGFloat){
        self.pics = pics
        self.name = name //
        self.lable = lable  //
        self.icon = icon //
        
        self.height = height
    }
    
    //普通栏
    convenience init(name: String, lable: String, icon: String){
        let name = name
        let icon = icon
        let lable = lable
        
        self.init(pics: nil, name: name, lable: lable, icon: icon, height: 44)
    }
    
    //输入栏
    convenience init(pics: [UIImage]){
        let pics = pics
        var height = CGFloat(0)
        
        if pics.count <= 3 {
            height = 200
        }else if pics.count <= 7{
            height = 300
        }else{
            height = 400
        }
        self.init(pics: pics, name: nil, lable: nil, icon: nil, height: height)
    }
}
