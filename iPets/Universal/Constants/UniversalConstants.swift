//
//  UniversalFuncsAndParas.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit
import CoreData


let mainQueue = DispatchQueue.main              //主线程
let globalQueue = DispatchQueue(label: "globalQueue")              //分支线程

let Width = UIScreen.main.bounds.width
let Height = UIScreen.main.bounds.height
let myOwnUrl = "http://weibo.com/micinyh/home?wvr=5"
let navigateBarHeight = CGFloat(64)
let tabBarHeight = CGFloat(49)

let standardFontNo = CGFloat(15)
let nameFont = UIFont.boldSystemFont(ofSize: standardFontNo) //寻宠界面的name字体
let textFont = UIFont.systemFont(ofSize: standardFontNo)//寻宠界面的text字体大小
let hideFont = UIFont.systemFont(ofSize: standardFontNo)//寻宠界面的hide按钮字体大小
let timeFont = UIFont.systemFont(ofSize: standardFontNo-3) //时间标签字体大小

let standardFont = UIFont.systemFont(ofSize: standardFontNo) //标准字体大小
let pageTitleFont = UIFont.boldSystemFont(ofSize: standardFontNo+3) //页面title的字体大小

let chatListPageTitleFont = UIFont.systemFont(ofSize: standardFontNo+1) //聊天列表页的标题字体大小
let chatListPageTextFont = UIFont.systemFont(ofSize: standardFontNo-1) //聊天列表页的lable字体大小
let chatListPageTimeFont = UIFont.systemFont(ofSize: standardFontNo-3) //聊天列表页的时间字体大小

let chatPageTimeFont = UIFont.systemFont(ofSize: standardFontNo-3) //聊天页的时间字体大小
let chatPageTextFont = UIFont.systemFont(ofSize: standardFontNo) //聊天页的文字字体大小
let chatPageInputTextFont = UIFont.systemFont(ofSize: standardFontNo) //聊天页的输入框文字字体大小

let sendPageNameFont = UIFont.systemFont(ofSize: standardFontNo) //发送状态页的name大小
let sendPageLableFont = UIFont.systemFont(ofSize: standardFontNo-1) //发送状态页的name大小
let sendPageInputTextFont = UIFont.systemFont(ofSize: standardFontNo) //发送状态页的输入框文字字体大小



let contectorListPageLableFont = UIFont.systemFont(ofSize: standardFontNo) //联系人页名字字体大小

let gusetNameFont = UIFont.systemFont(ofSize: standardFontNo+2) //详细资料界面的name字体
let gusetTextFont = UIFont.systemFont(ofSize: standardFontNo+1)//详细资料界面的text字体大小
let gusetLabelFont = UIFont.systemFont(ofSize: standardFontNo-1) //详细资料标签字体大小

let hotListDicName = "热门搜索"
let recordListDicName = "搜索历史"
let recordTitleFont = UIFont.systemFont(ofSize: standardFontNo-3)//搜索界面的text字体大小
let recordLabelFont = UIFont.systemFont(ofSize: standardFontNo+1) //搜索标签字体大小
let sellBuyLabelFont = UIFont.systemFont(ofSize: standardFontNo) //首页的文字大小


//==================Me Setting页的字体==========================
let settingPageNameFont = UIFont.systemFont(ofSize: standardFontNo+2) //设置页字体大小
let settingPageLabelFont = UIFont.systemFont(ofSize: standardFontNo) //设置页lable字体大小

//==================find页的字体==========================
let findPageLabelFont = UIFont.systemFont(ofSize: standardFontNo+3) //设置页lable字体大小


var myInfo = UserInfo(name: nil, icon: nil, nickname: nil)   //我的名字，头像，昵称 ，规则是昵称不能为空，且不能重复

//获得主色调
func getMainColor() -> UIColor{
    let color = UIColor(red: 7/255, green: 191/255, blue: 5/255, alpha: 0.9)
    return color
}

var realCity = "北京"

