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

class ChatData: NSObject {
    
    var chatType: Int //0代表对方的消息，1代表我的消息
    var chatBody: String //消息体
    var chatDate: Date
    var chatImage: String //图片
    
    init(chatType: Int, chatBody: String, time: Date, chatImage: String){
        self.chatType = chatType
        self.chatBody = chatBody
        self.chatDate = time
        self.chatImage = chatImage
        super.init()
    }
    
    //从nsobject解析回来
    init(coder aDecoder: NSCoder!){
        self.chatType = aDecoder.decodeObject(forKey: "chatType") as! Int
        self.chatBody = aDecoder.decodeObject(forKey: "chatBody") as! String
        self.chatImage = aDecoder.decodeObject(forKey: "chatImage") as! String
        self.chatDate = aDecoder.decodeObject(forKey: "time") as! Date
    }
    
    //编码成object
    func encodeWithCoder(_ aCoder: NSCoder!){
        aCoder.encode(chatType, forKey: "chatType")
        aCoder.encode(chatBody, forKey: "chatBody")
        aCoder.encode(chatImage, forKey: "chatImage")
        aCoder.encode(chatDate, forKey: "time")
    }
}
