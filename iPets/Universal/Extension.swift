//
//  Extension.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/25.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation

//扩展NSRange，让swift的string能使用stringByReplacingCharactersInRange
extension NSRange {
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = string.startIndex.advancedBy(self.location)
        let endIndex = startIndex.advancedBy(self.length)
        return startIndex..<endIndex
    }
}

// MARK: - 拓展日期类
extension NSDate {
    /**
     这个月有几天
     - parameter date: nsdate
     - returns: 天数
     */
    func TotaldaysInThisMonth(date : NSDate ) -> Int {
        let totaldaysInMonth: NSRange = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        return totaldaysInMonth.length
    }
    
    /**
     得到本月的第一天的是第几周
     - parameter date: nsdate
     - returns: 第几周
     */
    func toMonthOneDayWeek (date:NSDate) ->Int {
        let Week: NSInteger = NSCalendar.currentCalendar().ordinalityOfUnit(.Day, inUnit: NSCalendarUnit.WeekOfMonth, forDate: date)
        return Week-1
    }
    
    /// 返回当前日期 年份
    var currentYear:Int{
        get{
            return getFormatDate("yyyy")
        }
    }
    /// 返回当前日期 月份
    var currentMonth:Int{
        get{
            return getFormatDate("MM")
        }
    }
    /// 返回当前日期 天
    var currentDay:Int{
        get{
            return getFormatDate("dd")
        }
    }
    /// 返回当前日期 小时
    var currentHour:Int{
        get{
            return getFormatDate("HH")
        }
    }
    /// 返回当前日期 分钟
    var currentMinute:Int{
        get{
            return getFormatDate("mm")
        }
    }
    /// 返回当前日期 秒数
    var currentSecond:Int{
        get{
            return getFormatDate("ss")
        }
    }
    
    /**
     获取yyyy  MM  dd  HH mm ss
     - parameter format: 比如 GetFormatDate(yyyy) 返回当前日期年份
     - returns: 返回值
     */
    func getFormatDate(format:String)->Int{
        let dateFormatter:NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = format;
        let dateString:String = dateFormatter.stringFromDate(self);
        var dates:[String] = dateString.componentsSeparatedByString("")
        let Value  = dates[0]
        if(Value==""){
            return 0
        }
        return Int(Value)!
    }
}

