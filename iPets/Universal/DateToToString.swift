//
//  DateToToString.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/26.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class DateToToString: NSObject {
    
    //自定义的dateToString
    class func dateToStringBySelf(date : NSDate, format: String) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        // Date 转 String
        return dateFormatter.stringFromDate(date)
    }
    
    class func stringToData(string: String, format: String) -> NSDate {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        // String to Date
        return dateFormatter.dateFromString(string)!
    }
    
    //根据时间差，返回一个字符串 寻宠界面
    class func getFindPetsTimeFormat(time: NSDate) -> String {
        let timeNow = NSDate()
        let second = timeNow.timeIntervalSinceDate(time)
        if(second < 60){
            return "刚刚"
        }else if(second < 60*60){
            let minute = Int(second/60)
            return "\(minute)分钟前"
        }else if(second < 60*60*24){
            let hour = Int(second/60/60)
            return "\(hour)小时前"
        }else if(second < 60*60*24*2) {
            return "1天前"
        }else if(second < 60*60*24*3) {
            return "2天前"
        }else if(second < 60*60*24*4) {
            return "3天前"
        }else{
            return DateToToString.dateToStringBySelf(time, format: "yyyy-MM-dd HH:mm")
        }
    }
    
    //根据时间差，返回一个字符串 聊天界面
    class func getChatTimeFormat(time: NSDate) -> String {
        let timeNow = NSDate()
        
        //获取今天过的时间
        let todayL = DateToToString.stringToData("\(timeNow.currentYear)-\(timeNow.currentMonth)-\(timeNow.currentDay) 00:00:00",
                                                 format: "yyyy-MM-dd HH:mm:ss")
        let todaySecond = timeNow.timeIntervalSinceDate(todayL)
        
        let yestodaySecond = todaySecond + 24*60*60  //那么昨天就是今天过的时间 加上一天
        
        let second = timeNow.timeIntervalSinceDate(time)
        
        //今天  昨天  以后先不管了,第一个条件时判断今天，如果不是今天，昨天就只需判断秒数少于yestodaySecond
        if(second < todaySecond){
            return DateToToString.dateToStringBySelf(time, format: "HH:mm")
        }else if(second < yestodaySecond){
            let temp = DateToToString.dateToStringBySelf(time, format: "HH:mm")
            return "昨天 \(temp)"
        }else{
            return DateToToString.dateToStringBySelf(time, format: "yyyy-MM-dd HH:mm")
        }
    }
    
    //根据时间差，返回一个字符串 聊天list界面
    class func getChatListTimeFormat(time: NSDate) -> String {
        let timeNow = NSDate()
        
        //获取今天过的时间
        let todayL = DateToToString.stringToData("\(timeNow.currentYear)-\(timeNow.currentMonth)-\(timeNow.currentDay) 00:00:00",
                                                 format: "yyyy-MM-dd HH:mm:ss")
        let todaySecond = timeNow.timeIntervalSinceDate(todayL)
        
        let yestodaySecond = todaySecond + 24*60*60  //那么昨天就是今天过的时间 加上一天
        
        let second = timeNow.timeIntervalSinceDate(time)
        
        //今天  昨天  以后先不管了,第一个条件时判断今天，如果不是今天，昨天就只需判断秒数少于yestodaySecond
        if(second < todaySecond){
            return DateToToString.dateToStringBySelf(time, format: "HH:mm")
        }else if(second < yestodaySecond){
            return "昨天"
        }else{
            return DateToToString.dateToStringBySelf(time, format: "yy/MM/dd")
        }
    }

}
