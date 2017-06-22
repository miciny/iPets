//
//  GetMyInfo.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/25.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class GetInfo: NSObject {

    //获取自己的信息
    class func getMyInfo() -> UserInfo{
        var myIcon = UIImage()
        var myName = String()
        
        //从CoreData里读取数据,数据库肯定会有东西
        
        if let data = SQLLine.SelectedCordData("nickname='"+myNikename+"'", entityName: entityNameOfContectors){
            if data.count == 1{
                let myIconData = (data[0] as! Contectors).icon! as Data
                myIcon = UIImage(data: myIconData)!
                myName = (data[0] as! Contectors).name!
            }
        }
        return UserInfo(name: myName, icon: myIcon, nickname: myNikename)
    }
}
