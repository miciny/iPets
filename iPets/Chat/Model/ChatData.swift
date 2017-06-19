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
    var chatDate: Date
    var messageType: String  // 0文字，1图片，2语音
    
    var chatBody: String //消息体
    
    var chatImage: String //图片
    
    var voicePath: String
    var voiceLong: String
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.chatBody, forKey: "chatBody")
        aCoder.encode(self.chatImage, forKey: "chatImage")
        aCoder.encode(self.chatDate, forKey: "time")
        aCoder.encode(self.chatType, forKey: "chatType")
        aCoder.encode(self.voicePath, forKey: "voicePath")
        aCoder.encode(self.voiceLong, forKey: "voiceLong")
        aCoder.encode(self.messageType, forKey: "messageType")
    }
    
    init(chatType: String, messageType: String, chatBody: String, time: Date, chatImage: String, voicePath: String, voiceLong: String){
        self.chatType = chatType
        self.chatBody = chatBody
        self.chatDate = time
        self.chatImage = chatImage
        self.voicePath = voicePath
        self.voiceLong = voiceLong
        self.messageType = messageType
        super.init()
    }
    
    //
    convenience init(chatType: String, time: Date, chatBody: String) {
        self.init(chatType: chatType, messageType: "0", chatBody: chatBody, time: time, chatImage: "", voicePath: "", voiceLong: "")
    }
    
    convenience init(chatType: String, time: Date, chatImage: String) {
        self.init(chatType: chatType, messageType: "1", chatBody: "", time: time, chatImage: chatImage, voicePath: "", voiceLong: "")
    }
    
    convenience init(chatType: String, time: Date, voicePath: String, voiceLong: String) {
        self.init(chatType: chatType, messageType: "2", chatBody: "", time: time, chatImage: "", voicePath: voicePath, voiceLong: voiceLong)
    }
    
    //从nsobject解析回来
    required init(coder aDecoder: NSCoder){
        
        self.chatBody = aDecoder.decodeObject(forKey: "chatBody") as! String
        self.messageType = aDecoder.decodeObject(forKey: "messageType") as! String
        self.chatImage = aDecoder.decodeObject(forKey: "chatImage") as! String
        self.chatDate = aDecoder.decodeObject(forKey: "time") as! Date
        self.chatType = aDecoder.decodeObject(forKey: "chatType") as! String
        self.voicePath = aDecoder.decodeObject(forKey: "voicePath") as! String
        self.voiceLong = aDecoder.decodeObject(forKey: "voiceLong") as! String
        super.init()
    }
    
}
