//
//  MainChatModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/24.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

class MainChatListViewDataModel: NSObject {
    
    var name: String //聊天的名称
    var pic: UIImage? //聊天的图片
    var lable: String? //聊天的文字，最后一条
    var time: Date //聊天的时间
    var nickname: String
    var height: CGFloat
    
    init(pic: UIImage?, name: String, lable: String?, time: Date, nickname: String){
        self.pic = pic
        self.nickname = nickname
        self.name = name
        self.lable = lable
        self.time = time
        self.height = 80
    }
}
