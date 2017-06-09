//
//  NewsHeaderDataModule.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/29.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

//头图
class NewsHeaderDataModule: NSObject{
    var category: newsType!
    var newsId: String?
    var intro: String?
    var kpic: String?
    var pics_total: Int?
    var longTitle: String?
    var title: String?
    var link: String?

    init(category: newsType!, newsId: String?, intro: String?, kpic: String?, pics_total: Int?, longTitle: String?, title: String?, link: String?) {
        self.category = category
        self.newsId = newsId
        self.intro = intro
        self.pics_total = pics_total
        self.kpic = kpic
        self.longTitle = longTitle
        self.title = title
        self.link = link
    }
}
