//
//  LocalNewsDataModule.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/22.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

//正文
class LocalNewsDataModule: NSObject {
    var title: String?          //短标题
    var pics : JSON?            //正文中的图片，可能许多
    var videos: JSON?           //视频
    var content : String?       //正文
    var weibo : JSON?       //微博
    
    init(title: String? , pics: JSON?, content: String?, videos: JSON?, weibo: JSON?) {
        self.title = title
        self.pics = pics
        self.content = content
        self.videos = videos
        self.weibo = weibo
    }
}
