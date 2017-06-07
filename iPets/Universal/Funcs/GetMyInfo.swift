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
        var myNickname = String()
        
        //从CoreData里读取数据,数据库肯定会有东西
        let dataArray = SQLLine.SelectAllData(entityNameOfContectors)
        
        for data in dataArray{
            myNickname = (data as AnyObject).value(forKey: ContectorsNameOfNickname)! as! String
            if myNickname == myNickname{
                let myIconData = (data as AnyObject).value(forKey: ContectorsNameOfIcon)! as! Data
                myIcon = UIImage(data: myIconData)!
                myName = (data as AnyObject).value(forKey: ContectorsNameOfName)! as! String
                break
            }
        }
        return UserInfo(name: myName, icon: myIcon, nickname: myNickname)
    }
}
