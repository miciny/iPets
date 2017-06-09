//
//  NewsFoucsDataModule.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/18.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

//新闻类型
enum newsType: String{
    case video = "video"
    case hdpic = "hdpic"
    case cms = "cms"
    case url = "url"
    case blog = "blog"
    case original = "original"
    case live = "live"
    case zhuanlan = "zhuanlan"
    case subject = "subject"
    case unkown = "unkown"
    case plan = "plan"
    case mp = "mp"
    case consice = "consice"
}

//新闻显示类型
enum feedShowStyleType: String{
    case bigImage = "big_img_show"
    case common = "common"
    case unkown = "unkown"
}

//新闻列表
class NewsDataModule: NSObject {
    var newsId: String?         //新闻id
    var title: String?          //短标题
    var longTitle: String?      //长标题
    var source: String?         //来源
    var link: String?           //连接
    var pic: String?            //图片
    var kpic: String?           //图片
    var intro: String?          //简介
    var pubDate: Int?           //
    var articlePubDate: Int?    //
    var commentId: String?      //评论接口的id？
    var feedShowStyle: feedShowStyleType!  //显示类型，普通 大图
    var category: newsType!       //类型－高清图，新闻,广告等
    var comment: Int?           //总评论
    var commentStatus: Int?     //是否可评论
    var show: Int?              //显示评论数
    var all: Int?               //总评论
    var qreply: Int?            //
    var praise: Int?            //赞
    var dispraise: Int?         //踩
    var cellHeight: CGFloat!    //cell高度
    
    var list: JSON?             //图片
    var total: Int?          //图片总数
    var picTemplate: Int?       //图片cell中显示模版
    
    var videoPic: String?       //视频图片
    var videoRuntime: Int?      //视频时长
    var videoUrl: String?       //视频url
    
    //初始化
    init(newsId: String?, title: String?, longTitle: String?, source: String?, link: String?, pic: String?, kpic: String?, intro: String?, total: Int?, list: JSON?, pubDate: Int?, articlePubDate: Int?, commentId: String?, feedShowStyle: feedShowStyleType!, category: newsType!, comment: Int?, commentStatus: Int?, show: Int?, all: Int?, qreply: Int?, praise: Int?, dispraise: Int?, videoPic: String?, videoRuntime: Int?, videoUrl: String?, picTemplate: Int?, cellHeight: CGFloat) {
        
        self.newsId = newsId
        self.title = title
        self.longTitle = longTitle
        self.source = source
        self.link = link
        self.pic = pic
        self.kpic = kpic
        self.intro = intro
        self.pubDate = pubDate
        self.articlePubDate = articlePubDate
        self.commentId = commentId
        self.feedShowStyle = feedShowStyle
        self.category = category
        self.comment = comment
        self.commentStatus = commentStatus
        self.show = show
        self.all = all
        self.qreply = qreply
        self.praise = praise
        self.dispraise = dispraise
        
        self.list = list
        self.total = total
        self.picTemplate = picTemplate
        
        self.videoPic = videoPic
        self.videoRuntime = videoRuntime
        self.videoUrl = videoUrl
        
        self.cellHeight = cellHeight
    }
    
    //普通频道
    convenience init(newsId: String?, title: String?, longTitle: String?, source: String?, link: String?, pic: String?, kpic: String?, intro: String?, total: Int?, list: JSON?, pubDate: Int?, articlePubDate: Int?, commentId: String?, feedShowStyle: feedShowStyleType!, category: newsType!, comment: Int?, commentStatus: Int?, show: Int?, all: Int?, qreply: Int?, praise: Int?, dispraise: Int?, videoPic: String?, videoRuntime: Int?, videoUrl: String?) {
        
        
        var cellHeight = CGFloat()
        if let c = category {
            switch c {
            case .hdpic:
                cellHeight = 150
                
            default:
                if videoUrl != nil{
                    cellHeight = 270
                }else if feedShowStyle == feedShowStyleType.bigImage{
                    cellHeight = 270
                }else{
                    cellHeight = 90
                }
            }
        }
        
        self.init(newsId: newsId, title: title, longTitle: longTitle, source: source, link: link, pic: pic, kpic: kpic, intro: intro, total: total, list: list, pubDate: pubDate, articlePubDate: articlePubDate, commentId: commentId, feedShowStyle: feedShowStyle, category: category, comment: comment, commentStatus: commentStatus, show: show, all: all, qreply: qreply, praise: praise, dispraise: dispraise, videoPic: videoPic, videoRuntime: videoRuntime, videoUrl: videoUrl, picTemplate: nil, cellHeight: cellHeight)
    }
    
    //图片频道
    convenience init(newsId: String?, title: String?, longTitle: String?, source: String?, link: String?, pic: String?, kpic: String?, intro: String?, total: Int?, list: JSON?, pubDate: Int?, articlePubDate: Int?, commentId: String?, feedShowStyle: feedShowStyleType!, comment: Int?, commentStatus: Int?, show: Int?, all: Int?, qreply: Int?, praise: Int?, dispraise: Int?, picTemplate: Int?) {
        
        var cellHeight = CGFloat(300)
        if let p = picTemplate{
            switch p {
            case 1:
                cellHeight = 300
            case 2:
                cellHeight = 400
            default:
                cellHeight = 300
            }
        }
        
        self.init(newsId: newsId, title: title, longTitle: longTitle, source: source, link: link, pic: pic, kpic: kpic, intro: intro, total: total, list: list, pubDate: pubDate, articlePubDate: articlePubDate, commentId: commentId, feedShowStyle: feedShowStyle, category: newsType.hdpic, comment: comment, commentStatus: commentStatus, show: show, all: all, qreply: qreply, praise: praise, dispraise: dispraise, videoPic: nil, videoRuntime: nil, videoUrl: nil, picTemplate: picTemplate, cellHeight: cellHeight)
    }
    
    //视频频道
    convenience init(newsId: String?, title: String?, longTitle: String?, source: String?, link: String?, pic: String?, kpic: String?, intro: String?, total: Int?, pubDate: Int?, articlePubDate: Int?, commentId: String?, feedShowStyle: feedShowStyleType!, comment: Int?, commentStatus: Int?, show: Int?, all: Int?, qreply: Int?, praise: Int?, dispraise: Int?, videoPic: String?, videoRuntime: Int?, videoUrl: String?) {
        
        
        let cellHeight = CGFloat(250)
        
        self.init(newsId: newsId, title: title, longTitle: longTitle, source: source, link: link, pic: pic, kpic: kpic, intro: intro, total: total, list: nil, pubDate: pubDate, articlePubDate: articlePubDate, commentId: commentId, feedShowStyle: feedShowStyle, category: newsType.video, comment: comment, commentStatus: commentStatus, show: show, all: all, qreply: qreply, praise: praise, dispraise: dispraise, videoPic: videoPic, videoRuntime: videoRuntime, videoUrl: videoUrl, picTemplate: nil, cellHeight: cellHeight)
    }
}
