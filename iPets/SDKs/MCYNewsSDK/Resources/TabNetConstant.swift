//
//  TabNetConstant.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/21.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

//频道
enum requestChannel : String{
    case news_toutiao = "news_toutiao" //头条
    case news_funny = "news_funny" //搞笑频道
    case news_video = "news_video" //视频频道
    case news_pictrue = "news_pic" //图片频道
    case news_ent = "news_ent"   //娱乐
    case news_sports = "news_sports"  //体育
    case news_tech = "news_tech"  //科技
    case news_mil = "news_mil" //军事
    case news_unkown = "news_unkown" //未知频道
}


class TabNetConstant: NSObject {
    let constant = NetConstant() //需要修改的地方
    
    //tab通用参数
    var pullDirection: String { return "down" }
    var resource: String { return "feed" }
    var s: String { return "20" }
    var p: String { return "1" }
    
    var urlSign = "" //可能变
    var pullTimes = ""  //可能变
    var replacedFlag = "" //可能变
    var behavior = "" //可能变
    
    //普通的
    func getURL(_ channel: requestChannel) -> String{
        return "\(constant.baseURL)?resource=\(resource)&accessToken=\(constant.accessToken)&chwm=\(constant.chwm)&city=\(constant.city)&connectionType=\(constant.connectionType)&deviceId=\(constant.deviceId)&deviceModel=\(constant.deviceModel)&from=\(constant.from)&idfa=\(constant.idfa)&idfv=\(constant.idfv)&imei=\(constant.imei)&location=\(constant.location)&osVersion=\(constant.osVersion)&resolution=\(constant.resolution)&ua=\(constant.ua)&weiboSuid=\(constant.weiboSuid)&weiboUid=\(constant.weiboUid)&wm=\(constant.wm)&rand=\(constant.rand)&urlSign=\(urlSign)&behavior=\(behavior)&channel=\(channel.rawValue)&p=\(p)&pullDirection=\(pullDirection)&pullTimes=\(pullTimes)&replacedFlag=\(replacedFlag)&s=\(s)"
    }
    
    //头条
    var toutiaoRequestURL: String{
        constant.location = "39.957292%2C116.460226"
        constant.rand = "569"
        self.urlSign = "61770de896"
        self.pullTimes = "2"
        self.replacedFlag = "0"
        self.behavior = "manual"
        
        return getURL(requestChannel.news_toutiao)
    }
    
    var toutiaoUpRequestURL: String{
        return "http://newsapi.sina.cn/?resource=feed&accessToken=2.00Z2kOLCe3vYNCbb5ef9b5c4F1YabE&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=177fdc308713ea0a1c5218f43f36be37e813b141&deviceModel=apple-iphone6&from=6051193012&idfa=2C23459D-6869-479E-A7E6-26557304C466&idfv=DABE98C3-D189-4EE4-A6C7-4D60EDD231C0&imei=177fdc308713ea0a1c5218f43f36be37e813b141&location=39.957272%2C116.460241&osVersion=9.3.2&resolution=750x1334&ua=apple-iphone6__SinaNews__5.1.1__iphone__9.3.2&weiboSuid=6135334ec0&weiboUid=1998320113&wm=b207&rand=140&urlSign=5e8ae94c53&behavior=manual&channel=news_toutiao&downCursor=&p=2&pullDirection=up&pullTimes=1&replacedFlag=1&s=20"
    }
    
    //搞笑
    var gaoxiaoRequestURL: String{
        constant.location = "39.957292%2C116.460226"
        constant.rand = "945"
        self.urlSign = "0ccfba338e"
        self.pullTimes = "1"
        self.replacedFlag = "0"
        self.behavior = "auto"
        
        return getURL(requestChannel.news_funny)
    }
    
    var gaoxiaoUpRequestURL: String{
        return "http://newsapi.sina.cn/?resource=feed&accessToken=2.00Z2kOLCe3vYNCbb5ef9b5c4F1YabE&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=177fdc308713ea0a1c5218f43f36be377e376d41&deviceModel=apple-iphone6&from=6052093012&idfa=2C23459D-6869-479E-A7E6-26557304C466&idfv=DABE98C3-D189-4EE4-A6C7-4D60EDD231C0&imei=177fdc308713ea0a1c5218f43f36be377e376d41&location=39.957259%2C116.460106&osVersion=9.3.2&resolution=750x1334&ua=apple-iphone6__SinaNews__5.2__iphone__9.3.2&weiboSuid=6135334ec0&weiboUid=1998320113&wm=b207&rand=719&urlSign=f29ddd4c76&behavior=manual&channel=news_funny&listCount=24&p=2&pullDirection=up&pullTimes=1&replacedFlag=1&s=20"
    }
    
    //科技
    var kejiRequestURL: String{
        constant.location = "39.957292%2C116.460226"
        constant.rand = "825"
        self.urlSign = "65538488f3"
        self.pullTimes = "1"
        self.replacedFlag = "0"
        self.behavior = "auto"
        
        return getURL(requestChannel.news_tech)
    }
    
    var kejiUpRequestURL: String{
        return "http://newsapi.sina.cn/?resource=feed&accessToken=2.00Z2kOLCe3vYNCbb5ef9b5c4F1YabE&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=177fdc308713ea0a1c5218f43f36be377e376d41&deviceModel=apple-iphone6&from=6052093012&idfa=2C23459D-6869-479E-A7E6-26557304C466&idfv=DABE98C3-D189-4EE4-A6C7-4D60EDD231C0&imei=177fdc308713ea0a1c5218f43f36be377e376d41&location=39.957259%2C116.460106&osVersion=9.3.2&resolution=750x1334&ua=apple-iphone6__SinaNews__5.2__iphone__9.3.2&weiboSuid=6135334ec0&weiboUid=1998320113&wm=b207&rand=117&urlSign=9e4f7470d8&behavior=manual&channel=news_tech&listCount=24&p=2&pullDirection=up&pullTimes=1&replacedFlag=1&s=20"
    }
    
    //军事
    var junshiRequestURL: String{
        constant.location = "39.957292%2C116.460226"
        constant.rand = "178"
        self.urlSign = "01bf1699d5"
        self.pullTimes = "1"
        self.replacedFlag = "0"
        self.behavior = "auto"
        
        return getURL(requestChannel.news_mil)
    }
    
    var junshiUpRequestURL: String{
        return "http://newsapi.sina.cn/?resource=feed&accessToken=2.00Z2kOLCe3vYNCbb5ef9b5c4F1YabE&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=177fdc308713ea0a1c5218f43f36be377e376d41&deviceModel=apple-iphone6&from=6052093012&idfa=2C23459D-6869-479E-A7E6-26557304C466&idfv=DABE98C3-D189-4EE4-A6C7-4D60EDD231C0&imei=177fdc308713ea0a1c5218f43f36be377e376d41&location=39.957259%2C116.460106&osVersion=9.3.2&resolution=750x1334&ua=apple-iphone6__SinaNews__5.2__iphone__9.3.2&weiboSuid=6135334ec0&weiboUid=1998320113&wm=b207&rand=304&urlSign=b3a5b936b3&behavior=manual&channel=news_mil&listCount=24&p=2&pullDirection=up&pullTimes=1&replacedFlag=1&s=20"
    }
    
    //娱乐
    var yuleRequestURL: String{
        constant.location = "39.957292%2C116.460226"
        constant.rand = "778"
        self.urlSign = "31ba351eb7"
        self.pullTimes = "1"
        self.replacedFlag = "0"
        self.behavior = "auto"
        
        return getURL(requestChannel.news_ent)
    }
    
    var yuleUpRequestURL: String{
        return "http://newsapi.sina.cn/?resource=feed&accessToken=2.00Z2kOLCe3vYNCbb5ef9b5c4F1YabE&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=177fdc308713ea0a1c5218f43f36be377e376d41&deviceModel=apple-iphone6&from=6052093012&idfa=2C23459D-6869-479E-A7E6-26557304C466&idfv=DABE98C3-D189-4EE4-A6C7-4D60EDD231C0&imei=177fdc308713ea0a1c5218f43f36be377e376d41&location=39.957259%2C116.460106&osVersion=9.3.2&resolution=750x1334&ua=apple-iphone6__SinaNews__5.2__iphone__9.3.2&weiboSuid=6135334ec0&weiboUid=1998320113&wm=b207&rand=978&urlSign=eb7a7bbc4a&behavior=manual&channel=news_ent&listCount=23&p=2&pullDirection=up&pullTimes=1&replacedFlag=1&s=20"
    }
    
    //体育
    var tiyuRequestURL: String{
        constant.location = "39.957292%2C116.460226"
        constant.rand = "771"
        self.urlSign = "6209db4063"
        self.pullTimes = "1"
        self.replacedFlag = "0"
        self.behavior = "auto"
        
        return getURL(requestChannel.news_sports)
    }
    
    var tiyuUpRequestURL: String{
        return "http://newsapi.sina.cn/?resource=feed&accessToken=2.00Z2kOLCe3vYNCbb5ef9b5c4F1YabE&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=177fdc308713ea0a1c5218f43f36be377e376d41&deviceModel=apple-iphone6&from=6052093012&idfa=2C23459D-6869-479E-A7E6-26557304C466&idfv=DABE98C3-D189-4EE4-A6C7-4D60EDD231C0&imei=177fdc308713ea0a1c5218f43f36be377e376d41&location=39.957259%2C116.460106&osVersion=9.3.2&resolution=750x1334&ua=apple-iphone6__SinaNews__5.2__iphone__9.3.2&weiboSuid=6135334ec0&weiboUid=1998320113&wm=b207&rand=857&urlSign=cefa2e13d6&behavior=manual&channel=news_sports&listCount=24&p=2&pullDirection=up&pullTimes=1&replacedFlag=0&s=20"
    }
    
    
    //视频
    var videoRequestURL: String{
        
        constant.location = "39.957292%2C116.460226"
        constant.rand = "432"
        self.urlSign = "54da727dfc"
        self.pullTimes = "4"
        self.replacedFlag = "1"
        self.behavior = "manual"
        
        return getURL(requestChannel.news_video)
    }
    
    var videoUpRequestURL: String{
        return "http://newsapi.sina.cn/?resource=feed&accessToken=2.00Z2kOLCe3vYNCbb5ef9b5c4F1YabE&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=177fdc308713ea0a1c5218f43f36be377e376d41&deviceModel=apple-iphone6&from=6052093012&idfa=2C23459D-6869-479E-A7E6-26557304C466&idfv=DABE98C3-D189-4EE4-A6C7-4D60EDD231C0&imei=177fdc308713ea0a1c5218f43f36be377e376d41&location=39.957259%2C116.460106&osVersion=9.3.2&resolution=750x1334&ua=apple-iphone6__SinaNews__5.2__iphone__9.3.2&weiboSuid=6135334ec0&weiboUid=1998320113&wm=b207&rand=756&urlSign=5b4708f89d&behavior=manual&channel=news_video&listCount=10&p=2&pullDirection=up&pullTimes=1&replacedFlag=1&s=20"
    }
    
    
    //图片
    var picRequestURL: String{
        
        constant.location = "39.957292%2C116.460226"
        constant.rand = "122"
        self.urlSign = "86790a3dd9"
        self.pullTimes = "1"
        self.replacedFlag = "0"
        self.behavior = "auto"
        
        return getURL(requestChannel.news_pictrue)
    }
    
    var picUpRequestURL: String{
        return "http://newsapi.sina.cn/?resource=feed&accessToken=2.00Z2kOLCe3vYNCbb5ef9b5c4F1YabE&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=177fdc308713ea0a1c5218f43f36be377e376d41&deviceModel=apple-iphone6&from=6052093012&idfa=2C23459D-6869-479E-A7E6-26557304C466&idfv=DABE98C3-D189-4EE4-A6C7-4D60EDD231C0&imei=177fdc308713ea0a1c5218f43f36be377e376d41&location=39.957259%2C116.460106&osVersion=9.3.2&resolution=750x1334&ua=apple-iphone6__SinaNews__5.2__iphone__9.3.2&weiboSuid=6135334ec0&weiboUid=1998320113&wm=b207&rand=358&urlSign=aa3e007cda&behavior=manual&channel=news_pic&listCount=20&p=2&pullDirection=up&pullTimes=1&replacedFlag=1&s=20"
    }
}
