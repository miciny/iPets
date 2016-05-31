//
//  MainChatModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/24.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

class MainChatModel: NSObject {
    
    var name: String //聊天的名称
    var pic: UIImage //聊天的图片
    var lable: String //聊天的文字，最后一条
    var time: NSDate //聊天的时间
    var nickname: String
    var view: UIView
    
    init(pic: UIImage, name: String, lable: String, time: NSDate, view: UIView, nickname: String){
        self.pic = pic
        self.nickname = nickname
        self.name = name
        self.lable = lable
        self.time = time
        self.view = view
    }
    
    convenience init(pic: UIImage, name: String, lable: String, time: NSDate, nickname: String) {
        let pic = pic
        let nickname = nickname
        let name = name
        let lable = lable
        let time = time
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 80))

        self.init(pic: pic, name: name, lable: lable, time: time, view: view, nickname: nickname)
    }
}
