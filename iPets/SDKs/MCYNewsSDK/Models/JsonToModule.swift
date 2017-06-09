//
//  JsonToModule.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/18.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

//json转模型时，类型
enum moduleType {
    case common
    case pic
    case video
}

class JsonToModule: NSObject {
    
    //moduleType,普通新闻
    class func NewsJsonToModule(_ json: JSON, type: moduleType) -> NewsDataModule?{
        let news = json
        //通用
        let newsId: String? = news["newsId"].stringValue
        let title = news["title"].stringValue
        let longTitle = news["longTitle"].stringValue
        let source = news["source"].stringValue
        let link = news["link"].stringValue
        let pic = news["pic"].stringValue
        let kpic = news["kpic"].stringValue
        let intro = news["intro"].stringValue
        let pubDate = news["pubDate"].intValue
        let articlePubDate = news["articlePubDate"].intValue
        let commentId = news["commentId"].stringValue
        let feedShowStyle = news["feedShowStyle"].stringValue
        let comment = news["comment"].intValue
        let commentStatus = news["commentCountInfo"]["commentStatus"].intValue
        let qreply = news["commentCountInfo"]["qreply"].intValue
        let show = news["commentCountInfo"]["show"].intValue
        let all = news["commentCountInfo"]["all"].intValue
        let praise = news["commentCountInfo"]["praise"].intValue
        let dispraise = news["commentCountInfo"]["dispraise"].intValue
        
        //新闻类型
        let category = news["category"].stringValue
        
        //图片
        let list = news["pics"]["list"] //图片list 这个是一个json
        let total = news["pics"]["total"].intValue //图片总数
        let picTemplate = news["pics"]["picTemplate"].intValue //图片cell中显示模版
        
        //视频
        let videoPic = news["videoInfo"]["pic"].stringValue
        let videoRuntime = news["videoInfo"]["runtime"].intValue
        let videoUrl = news["videoInfo"]["url"].stringValue
        
        var newsModule: NewsDataModule?
        
        //如果没有，返回空
        if newsId == nil || newsId == ""{
            return nil
        }
        
        switch type {
            
        case .common:
            newsModule = NewsDataModule(newsId: newsId,
                                        title: title,
                                        longTitle: longTitle,
                                        source: source,
                                        link: link,
                                        pic: pic,
                                        kpic: kpic,
                                        intro: intro,
                                        total: total,
                                        list: list,
                                        pubDate: pubDate,
                                        articlePubDate: articlePubDate,
                                        commentId: commentId,
                                        feedShowStyle: DataFormat.showType(feedShowStyle),
                                        category: DataFormat.categoryToNewsType(category),
                                        comment: comment,
                                        commentStatus: commentStatus,
                                        show: show,
                                        all: all,
                                        qreply: qreply,
                                        praise: praise,
                                        dispraise: dispraise,
                                        videoPic: (videoPic=="" ? nil : videoPic),
                                        videoRuntime: videoRuntime,
                                        videoUrl: (videoUrl=="" ? nil : videoUrl)
            )
            
        case .video:
            newsModule = NewsDataModule(newsId: newsId,
                                        title: title,
                                        longTitle: longTitle,
                                        source: source,
                                        link: link,
                                        pic: pic,
                                        kpic: kpic,
                                        intro: intro,
                                        total: total,
                                        pubDate: pubDate,
                                        articlePubDate: articlePubDate,
                                        commentId: commentId,
                                        feedShowStyle: DataFormat.showType(feedShowStyle),
                                        comment: comment,
                                        commentStatus: commentStatus,
                                        show: show,
                                        all: all,
                                        qreply: qreply,
                                        praise: praise,
                                        dispraise: dispraise,
                                        videoPic: (videoPic=="" ? nil : videoPic),
                                        videoRuntime: videoRuntime,
                                        videoUrl: (videoUrl=="" ? nil : videoUrl)
            )
            
        case .pic:
            newsModule = NewsDataModule(newsId: newsId,
                                        title: title,
                                        longTitle: longTitle,
                                        source: source,
                                        link: link,
                                        pic: pic, kpic: kpic,
                                        intro: intro,
                                        total: total,
                                        list: list,
                                        pubDate: pubDate,
                                        articlePubDate: articlePubDate,
                                        commentId: commentId,
                                        feedShowStyle: DataFormat.showType(feedShowStyle),
                                        comment: comment,
                                        commentStatus: commentStatus,
                                        show: show,
                                        all: all,
                                        qreply: qreply,
                                        praise: praise,
                                        dispraise: dispraise,
                                        picTemplate: picTemplate)
            
        }
        return newsModule!
    }
    
    
    //头图
    class func HeaderJsonToModule(_ json: JSON) -> NewsHeaderDataModule{
        let header = json
        
        let category = header["category"].stringValue
        let newsId = header["newsId"].stringValue
        let intro = header["intro"].stringValue
        let kpic = header["kpic"].stringValue
        let pics_total = header["pics"]["total"].intValue
        let longTitle = header["longTitle"].stringValue
        let title = header["title"].stringValue
        let link = header["link"].stringValue
        
        let headerModule = NewsHeaderDataModule(category: DataFormat.categoryToNewsType(category), newsId: newsId, intro: intro, kpic: kpic, pics_total: pics_total, longTitle: longTitle, title: title, link: link)
        return headerModule
    }
    
    
    //图集
    class func PicsJsonToModule(_ json: JSON) -> PicsDataModule{
        let pics = json
        //通用
        let pic = pics["pic"].stringValue
        let alt = pics["alt"].stringValue
        let kpic = pics["kpic"].stringValue
        let width = pics["width"].intValue
        let height = pics["height"].intValue
        let gif = pics["gif"].stringValue
        
        let picsModule = PicsDataModule(pic: pic, alt: alt, kpic: kpic, width: width, height: height, gif: (gif=="" ? nil : gif))
        return picsModule
    }
    
    
    //正文
    class func LocalNewJsonToModule(_ json: JSON) -> LocalNewsDataModule{

        //通用
        let videos = json["videosModule"]
        let pics = json["pics"]
        let weibo = json["singleWeibo"]
        let title = json["title"].stringValue
        let content = json["content"].stringValue
        
        let picsModule = LocalNewsDataModule(title: title, pics: pics, content: content, videos: videos, weibo: weibo)
        return picsModule
    }
}
