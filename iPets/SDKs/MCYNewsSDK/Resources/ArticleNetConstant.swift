//
//  ArticleNetConstant.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/21.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ArticleNetConstant: NSObject {
    let constant = NetConstant() //需要修改的地方
    
    var resource: String { return "article" }
    
    var link = "" //可能变
    var newsId = "" //可能变
    var postt = "" //可能变
    var urlSign = "" //可能变
    
    //普通的
    func getURL() -> String{
        return "\(constant.baseURL)?resource=\(resource)&accessToken=\(constant.accessToken)&chwm=\(constant.chwm)&city=\(constant.city)&connectionType=\(constant.connectionType)&deviceId=\(constant.deviceId)&deviceModel=\(constant.deviceModel)&from=\(constant.from)&idfa=\(constant.idfa)&idfv=\(constant.idfv)&imei=\(constant.imei)&location=\(constant.location)&osVersion=\(constant.osVersion)&resolution=\(constant.resolution)&ua=\(constant.ua)&weiboSuid=\(constant.weiboSuid)&weiboUid=\(constant.weiboUid)&wm=\(constant.wm)&rand=\(constant.rand)&urlSign=\(urlSign)&idfa=\(constant.idfa)&link=\(link)&newsId=\(newsId)&postt=\(postt)&userUid=\(constant.userUid)"
    }
    
    // 图片频道，进入图集
    func getPicChannelArticleURL(_ link: String, postt: String, newsId: String) -> String{
        constant.location = "39.957292%2C116.460226"
        constant.rand = "331"
        self.urlSign = "b43a838b10"
        self.link = link
        self.postt = postt
        self.newsId = newsId
        
        return getURL()
    }
    
    
    // 新闻,video
    func getCommonArticleURL(_ link: String, postt: String, newsId: String) -> String{
//        constant.location = "39.957292%2C116.460226"
//        constant.rand = "293"
//        self.urlSign = "eed21ecef6"
//        self.link = link
//        self.postt = postt
//        self.newsId = newsId
//        
//        return getURL()
        
        return "http://newsapi.sina.cn/?resource=article&accessToken=2.00Z2kOLCe3vYNCbb5ef9b5c4F1YabE&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=177fdc308713ea0a1c5218f43f36be37eaacbbcf&deviceModel=apple-iphone6&from=6051193012&idfa=2C23459D-6869-479E-A7E6-26557304C466&idfv=DABE98C3-D189-4EE4-A6C7-4D60EDD231C0&imei=177fdc308713ea0a1c5218f43f36be37eaacbbcf&location=39.957292%2C116.460226&osVersion=9.3.2&resolution=750x1334&ua=apple-iphone6__SinaNews__5.1.1__iphone__9.3.2&weiboSuid=6135334ec0&weiboUid=1998320113&wm=b207&rand=523&urlSign=007e3df499&link=http%3A//ent.sina.cn/film/chinese/2016-07-15/detail-ifxuapvw2034026.d.html?fromsinago%3D1&newsId=fxuapvw2034026-comos-ent-cms&postt=news_news_ent_feed_87"
    }
    

}
