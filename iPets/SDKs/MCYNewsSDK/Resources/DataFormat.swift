//
//  DataFormat.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/9.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation

class DataFormat{
    //评论数
    class func commentFormat(_ comment: Int) -> String{
        if comment > 99999 {
            let TTcomment = comment / 10000
            return String(TTcomment)+"万"
        }else{
            return String(comment)
        }
    }
    
    //根据string 返回一个feedShowStyleType
    class func showType(_ feedShowStyle: String) -> feedShowStyleType{
        switch feedShowStyle {
        case "big_img_show":
            return feedShowStyleType.bigImage
        case "common":
            return feedShowStyleType.common
        default:
            logger.info("feedShowStyle,未显示的类型"+feedShowStyle)
            return feedShowStyleType.unkown
        }
    }
    
    
    //根据string 返回一个newsType
    class func categoryToNewsType(_ category: String) -> newsType{
        switch category {
        case "cms":
            return newsType.cms
        case "blog":
            return newsType.blog
        case "hdpic":
            return newsType.hdpic
        case "original":
            return newsType.original
        case "url":
            return newsType.url
        case "video":
            return newsType.video
        case "subject":
            return newsType.subject
        case "live":
            return newsType.live
        case "zhuanlan":
            return newsType.zhuanlan
        case "plan":
            return newsType.plan
        case "mp":
            return newsType.mp
        case "consice":
            return newsType.consice
        default:
            logger.info("category,未显示的类型"+category)
            return newsType.unkown
        }
    }
    
    //视频时长转为时分秒显示
    class func runtimeToDate(_ runtime: Int) -> String{
        
        let sTemp = runtime/1000
        
        let h = sTemp/3600
        let m = (sTemp%3600)/60
        let s = ((sTemp%3600)%60)
        
        let hStr = h>9 ? "\(h)" : "0\(h)"
        let mStr = m>9 ? "\(m)" : "0\(m)"
        let sStr = s>9 ? "\(s)" : "0\(s)"
        
        return hStr=="00" ? mStr + ":" + sStr : hStr + ":" + mStr + ":" + sStr
    }
    
    
    //根据string 返回一个channel
    class func strToNewsChannel(_ str: String) -> requestChannel{
        switch str {
        case "头条":
            return requestChannel.news_toutiao
        case "搞笑":
            return requestChannel.news_funny
        case "娱乐":
            return requestChannel.news_ent
        case "体育":
            return requestChannel.news_sports
        case "军事":
            return requestChannel.news_mil
        case "科技":
            return requestChannel.news_tech
        default:
            logger.info("str,未显示的类型"+str)
            return requestChannel.news_unkown
        }
    }

}
