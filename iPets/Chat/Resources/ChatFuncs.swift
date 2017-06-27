//
//  ChatFuncs.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/27.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class ChatFuncs: NSObject {

    
    //获取配置信息
    class func getSettingModel(_ nicknameStr: String) -> MainChatListViewDataSettingModel?{
        let chatsData = SaveDataModel()
        let chatSettingData = chatsData.loadChatSettingDataFromTempDirectory()
        for data in chatSettingData{
            let nickName = data.nickname
            if nickName == nicknameStr{
                return data
            }
        }
        return nil
    }
}
