//
//  NetConstant.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/17.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation

class NetConstant: NSObject {
    
    //api接口地址
    var baseURL: String { return "http://newsapi.sina.cn/" }
    
    //通用参数,get方法只读
    var accessToken: String { return "2.00Z2kOLCe3vYNCbb5ef9b5c4F1YabE"}
    var chwm: String { return "3023_0001" }
    var city: String { return "CHXX0008" }
    var connectionType: String { return "2" }
    var deviceId: String { return "177fdc308713ea0a1c5218f43f36be37eaacbbcf" }
    var deviceModel: String { return "apple-iphone6" }
    var from: String { return "6051193012" }
    var idfa: String { return "2C23459D-6869-479E-A7E6-26557304C466" }
    var idfv: String { return "DABE98C3-D189-4EE4-A6C7-4D60EDD231C0" }
    var osVersion: String { return "9.3.2" }
    var resolution: String { return "750x1334" }
    var ua: String { return "apple-iphone6__SinaNews__5.1.1__iphone__9.3.2" }
    var weiboSuid: String { return "6135334ec0" }
    var weiboUid: String { return "1998320113" }
    var wm: String { return "b207" }
    var userUid: String { return "1998320113" }
    var imei: String { return "177fdc308713ea0a1c5218f43f36be37eaacbbcf" }
    
    var location = "" //地址可能变
    var rand = "" //可能变
    
    
    //头条的参数，url参数的顺序还有影响？先拼接吧
    var hotRequestPara: [String : String]{
        var para = [String : String]()
        para = [
            "resource": "feed",
            "accessToken": "2.00Z2kOLCe3vYNCbb5ef9b5c4F1YabE",
            "chwm": "3023_0001",
            "city": "CHXX0008",  //城市代码
            "connectionType": "2",
            "deviceId": "177fdc308713ea0a1c5218f43f36be37eac20184",
            "deviceModel": "apple-iphone6",
            "from": "6051093012",
            "idfa": "2C23459D-6869-479E-A7E6-26557304C466",
            "idfv": "DE611E45-8266-4BEE-96E0-B86B2FE968DF",
            "imei": "177fdc308713ea0a1c5218f43f36be37eac20184",
            "location": "40.046776,116.344246",  //位置信息
            "osVersion": "9.3.2",  //系统版本
            "resolution": "750x1334",
            "token": "892ab581b3ae59aa47a442a54583adf91024adac7744f196a0095a2d7e629cc3",  //token信息
            "ua": "apple-iphone6__SinaNews__5.1__iphone__9.3.2",  //标示
            "weiboSuid": "6135334ec0",
            "weiboUid": "1998320113",
            "wm": "b207",
            "rand": "521",
            "urlSign": "2f94c74bf7",
            "behavior": "manual",
            "channel": "news_toutiao",  //频道
            "p": "1",
            "pullDirection": "down", //方向，刷新或加载更多
            "pullTimes": "4",
            "replacedFlag": "1",
            "s": "20",
        ]
        return para
    }
    
}
