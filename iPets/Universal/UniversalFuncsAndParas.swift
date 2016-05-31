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

let Width = UIScreen.mainScreen().bounds.width
let Height = UIScreen.mainScreen().bounds.height
let myOwnUrl = "http://weibo.com/micinyh/home?wvr=5"
let navigateBarHeight = CGFloat(64)
let tabBarHeight = CGFloat(49)

//setting的数据库
let entityNameOfSettingData = "SettingData"
let settingDataNameOfMyIcon = "myIcon"
let settingDataNameOfMyAddress = "myAddress"
let settingDataNameOfMySex = "mySex"
let settingDataNameOfMyMotto = "myMotto"
let settingDataNameOfMyNickname = "myNickname"
let settingDataNameOfMyName = "myName"

//chatList的数据库
let entityNameOfChatList = "ChatList"
let ChatListNameOfTitle = "title"
let ChatListNameOfLable = "lable"
let ChatListNameOfTime = "time"
let ChatListNameOfIcon = "icon"
let ChatListNameOfNickname = "nickname"

//contectors的数据库
let entityNameOfContectors = "Contectors"
let ContectorsNameOfName = "name"
let ContectorsNameOfSex = "sex"
let ContectorsNameOfNickname = "nickname"
let ContectorsNameOfIcon = "icon"
let ContectorsNameOfRemark = "remark"
let ContectorsNameOfAddress = "address"
let ContectorsNameOfHttp = "http"

//searchRecord的数据库
let entityNameOfSearchRecord = "SearchRecord"
let SearchRecordNameOfLabel = "label"
let SearchRecordNameOfTime = "time"

let chatDataSaveFolderName = "TempChats" //保存聊天记录的本地目录名字
let FindMyPetsDataSaveFolderName = "FindPets" //保存附近寻宠记录的本地目录名字
let FindMyPetsDataSaveFileName = "FindPets.plist" //保存附近寻宠记录的本地文件名字

let findPetsImageDataSaveFolderName = "FindPets" //保存寻宠页图片的本地目录名字
let ChatImageDataSaveFolderName = "Chats" //保存聊天页图片的本地目录名字

let standardFontNo = CGFloat(15)
let nameFont = UIFont.boldSystemFontOfSize(standardFontNo) //寻宠界面的name字体
let textFont = UIFont.systemFontOfSize(standardFontNo)//寻宠界面的text字体大小
let hideFont = UIFont.systemFontOfSize(standardFontNo)//寻宠界面的hide按钮字体大小
let timeFont = UIFont.systemFontOfSize(standardFontNo-3) //时间标签字体大小

let standardFont = UIFont.systemFontOfSize(standardFontNo) //标准字体大小
let pageTitleFont = UIFont.boldSystemFontOfSize(standardFontNo+3) //页面title的字体大小

let chatListPageTitleFont = UIFont.systemFontOfSize(standardFontNo+1) //聊天列表页的标题字体大小
let chatListPageTextFont = UIFont.systemFontOfSize(standardFontNo-1) //聊天列表页的lable字体大小
let chatListPageTimeFont = UIFont.systemFontOfSize(standardFontNo-3) //聊天列表页的时间字体大小

let chatPageTimeFont = UIFont.systemFontOfSize(standardFontNo-3) //聊天页的时间字体大小
let chatPageTextFont = UIFont.systemFontOfSize(standardFontNo) //聊天页的文字字体大小
let chatPageInputTextFont = UIFont.systemFontOfSize(standardFontNo) //聊天页的输入框文字字体大小

let sendPageNameFont = UIFont.systemFontOfSize(standardFontNo) //发送状态页的name大小
let sendPageLableFont = UIFont.systemFontOfSize(standardFontNo-1) //发送状态页的name大小
let sendPageInputTextFont = UIFont.systemFontOfSize(standardFontNo) //发送状态页的输入框文字字体大小

let settingPageNameFont = UIFont.systemFontOfSize(standardFontNo+2) //设置页字体大小
let settingPageLableFont = UIFont.systemFontOfSize(standardFontNo) //设置页lable字体大小

let contectorListPageLableFont = UIFont.systemFontOfSize(standardFontNo) //联系人页名字字体大小

let gusetNameFont = UIFont.systemFontOfSize(standardFontNo+2) //详细资料界面的name字体
let gusetTextFont = UIFont.systemFontOfSize(standardFontNo+1)//详细资料界面的text字体大小
let gusetLabelFont = UIFont.systemFontOfSize(standardFontNo-1) //详细资料标签字体大小

let hotListDicName = "热门搜索"
let recordListDicName = "搜索历史"
let recordTitleFont = UIFont.systemFontOfSize(standardFontNo-3)//搜索界面的text字体大小
let recordLabelFont = UIFont.systemFontOfSize(standardFontNo+1) //搜索标签字体大小

let sellBuyLabelFont = UIFont.systemFontOfSize(standardFontNo) //首页的文字大小


var myInfo = UserInfo(name: nil, icon: nil, nickname: nil)   //我的名字，头像，昵称 ，规则是昵称不能为空，且不能重复


//获得主色调
func getMainColor() -> UIColor{
    let color = UIColor(red: 7/255, green: 191/255, blue: 5/255, alpha: 0.9)
    return color
}

//根据文字获得大小
func sizeWithText(text: NSString, font: UIFont, maxSize: CGSize) -> CGSize{
    let attrs : NSDictionary = [NSFontAttributeName:font]
    return text.boundingRectWithSize(maxSize, options: .UsesLineFragmentOrigin,
                                     attributes: attrs as? [String : AnyObject], context: nil).size
}

//获得一个随机数
func getIntRandomNum(max: Int, min: Int) -> Int {
    let max: UInt32 = UInt32(max)
    let min: UInt32 = UInt32(min)
    return Int(arc4random_uniform(max - min) + min)
}

//通过string 和 一个图片 创建一个二维码
func createQRForString(qrString: String?, qrImage: UIImage?) -> UIImage?{
    
    if let sureQRString = qrString {
        let stringData = sureQRString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        // 创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter!.setValue(stringData, forKey: "inputMessage")
        qrFilter!.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter!.outputImage
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter!.setDefaults()
        colorFilter!.setValue(qrCIImage, forKey: "inputImage")
        colorFilter!.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter!.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        // 返回二维码image
        let codeImage = UIImage(CIImage: colorFilter!.outputImage!.imageByApplyingTransform(CGAffineTransformMakeScale(5, 5)))
        
        // 通常,二维码都是定制的,中间都会放想要表达意思的图片
        if let iconImage = qrImage {
            let rect = CGRectMake(0, 0, codeImage.size.width, codeImage.size.height)
            UIGraphicsBeginImageContext(rect.size)
            
            codeImage.drawInRect(rect)
            let avatarSize = CGSizeMake(rect.size.width * 0.25, rect.size.height * 0.25)
            let x = (rect.width - avatarSize.width) * 0.5
            let y = (rect.height - avatarSize.height) * 0.5
            iconImage.drawInRect(CGRectMake(x, y, avatarSize.width, avatarSize.height))
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            return resultImage
        }
        return codeImage
    }
    return nil
}

// delay(2) { print("2 秒后输出") }
// let task = delay(5) { print("拨打 110") }
// 仔细想一想..
// 还是取消为妙..
// cancel(task)

typealias Task = (cancel : Bool) -> Void

func delay(time:NSTimeInterval, task:()->()) ->  Task? {
    
    func dispatch_later(block:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(time * Double(NSEC_PER_SEC))),
            dispatch_get_main_queue(),
            block)
    }
    
    var closure: dispatch_block_t? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                dispatch_async(dispatch_get_main_queue(), internalClosure);
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(cancel: false)
        }
    }
    
    return result;
}

func cancel(task:Task?) {
    task?(cancel: true)
}