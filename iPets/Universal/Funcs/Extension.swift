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
        let startIndex = string.index(string.startIndex, offsetBy: self.location)
        let endIndex = string.index(startIndex, offsetBy: self.length)
        return startIndex ..< endIndex
    }
}

// MARK: - 拓展日期类
extension Date {
    /**
     这个月有几天
     - parameter date: nsdate
     - returns: 天数
     */
    func totalDaysInThisMonth() -> Int{
        let totalDaysInMonth = NSCalendar.current.range(of: .day, in: .month, for: self)
        return totalDaysInMonth!.count
    }
    
    /**
     得到本月的第一天的是第几周
     - parameter date: nsdate
     - returns: 第几周
     */
    func toMonthOneDayWeek() -> Int{
        let Week = NSCalendar.current.ordinality(of: .day, in: .weekOfMonth, for: self)!
        return Week-1
    }
    
    /// 返回当前日期 年份
    var currentYear: Int{
        get{
            return getFormatDate(format: "yyyy")
        }
    }
    /// 返回当前日期 月份
    var currentMonth: Int{
        get{
            return getFormatDate(format: "MM")
        }
    }
    /// 返回当前日期 天
    var currentDay: Int{
        get{
            return getFormatDate(format: "dd")
        }
    }
    /// 返回当前日期 小时
    var currentHour: Int{
        get{
            return getFormatDate(format: "HH")
        }
    }
    /// 返回当前日期 分钟
    var currentMinute: Int{
        get{
            return getFormatDate(format: "mm")
        }
    }
    /// 返回当前日期 秒数
    var currentSecond: Int{
        get{
            return getFormatDate(format: "ss")
        }
    }
    
    /**
     获取yyyy  MM  dd  HH mm ss
     - parameter format: 比如 GetFormatDate(yyyy) 返回当前日期年份
     - returns: 返回值
     */
    func getFormatDate(format: String) -> Int{
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let dateString: String = dateFormatter.string(from: self as Date)
        var dates: [String] = dateString.components(separatedBy: "")
        let Value = dates[0]
        if(Value == ""){
            return 0
        }
        return Int(Value)!
    }
}

