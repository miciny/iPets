//
//  MainChatListViewDataSettingModel.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class MainChatListViewDataSettingModel: NSObject, NSCoding {
    var nickname: String
    var top: String  //置顶 1  不是1都不是置顶
    var chatBIMPath: String? //聊天背景图的地址
    
    init(nickname: String, top: String, chatBIMPath: String?) {
        self.nickname = nickname
        self.top = top
        self.chatBIMPath = chatBIMPath
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        if let data = self.chatBIMPath{
            aCoder.encode(data, forKey: "chatBIMPath")
        }
        aCoder.encode(self.nickname, forKey: "nickname")
        aCoder.encode(self.top, forKey: "top")
    }
    
    //从nsobject解析回来
    required init(coder aDecoder: NSCoder){
        
        self.nickname = aDecoder.decodeObject(forKey: "nickname") as! String
        self.top = aDecoder.decodeObject(forKey: "top") as! String
        self.chatBIMPath = aDecoder.decodeObject(forKey: "chatBIMPath") as? String
        
        super.init()
    }

}
