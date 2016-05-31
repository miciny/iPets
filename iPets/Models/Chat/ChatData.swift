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
    var chatDate: NSDate
    var chatImage: String //图片
    
    init(chatType: Int, chatBody: String, time: NSDate, chatImage: String){
        self.chatType = chatType
        self.chatBody = chatBody
        self.chatDate = time
        self.chatImage = chatImage
        super.init()
    }
    
    //从nsobject解析回来
    init(coder aDecoder:NSCoder!){
        self.chatType=aDecoder.decodeObjectForKey("chatType") as! Int
        self.chatBody=aDecoder.decodeObjectForKey("chatBody") as! String
        self.chatImage=aDecoder.decodeObjectForKey("chatImage") as! String
        self.chatDate=aDecoder.decodeObjectForKey("time") as! NSDate
    }
    
    //编码成object
    func encodeWithCoder(aCoder:NSCoder!){
        aCoder.encodeObject(chatType,forKey:"chatType")
        aCoder.encodeObject(chatBody,forKey:"chatBody")
        aCoder.encodeObject(chatImage,forKey:"chatImage")
        aCoder.encodeObject(chatDate,forKey:"time")
    }
}
