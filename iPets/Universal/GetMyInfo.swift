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
        let SettingDataArray = SQLLine.SelectAllData(entityNameOfSettingData)
        
        if(SettingDataArray.count > 0){
            let myIconData = SettingDataArray.lastObject!.valueForKey(settingDataNameOfMyIcon)! as! NSData
            myIcon = UIImage(data: myIconData)!
            myName = SettingDataArray.lastObject!.valueForKey(settingDataNameOfMyName)! as! String
            myNickname = SettingDataArray.lastObject!.valueForKey(settingDataNameOfMyNickname)! as! String
        }else{
            let defaultIcon = UIImage(named: "defaultIcon")
            myIcon = defaultIcon!
            myName = ""
            myNickname = ""
        }
        
        return UserInfo(name: myName, icon: myIcon, nickname: myNickname)
    }
}
