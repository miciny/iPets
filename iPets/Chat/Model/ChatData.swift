//
//  ChatData.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/26.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

/*
 用户聊天记录
 */

class ChatData: NSObject, NSCoding{
    
    var chatType: String //消息类型 1我 0你
    var chatBody: String //消息体
    var chatDate: Date
    var chatImage: String //图片
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.chatBody, forKey: "chatBody")
        aCoder.encode(self.chatImage, forKey: "chatImage")
        aCoder.encode(self.chatDate, forKey: "time")
        aCoder.encode(self.chatType, forKey: "chatType")
    }
    
    init(chatType: String, chatBody: String, time: Date, chatImage: String){
        self.chatType = chatType
        self.chatBody = chatBody
        self.chatDate = time
        self.chatImage = chatImage
        super.init()
    }
    
    //从nsobject解析回来
    required init(coder aDecoder: NSCoder){
        
        self.chatBody = aDecoder.decodeObject(forKey: "chatBody") as! String
        self.chatImage = aDecoder.decodeObject(forKey: "chatImage") as! String
        self.chatDate = aDecoder.decodeObject(forKey: "time") as! Date
        self.chatType = aDecoder.decodeObject(forKey: "chatType") as! String
        super.init()
    }
    
}
