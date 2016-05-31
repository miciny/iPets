//
//  PingYingString.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/28.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

//中文字符获取拼音首字母
class PinYinString: NSObject {
    
    class func charactorType(aString:String) -> Int{
        
        let char = aString.substringToIndex(aString.startIndex.advancedBy(1))
        
        let eRegex: String = "^[a-zA-z]+$"
        let eTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", eRegex)
        if eTest.evaluateWithObject(char){
            return 1
        }
        let zRegex: String = "^[\\u4e00-\\u9fa5]"
        let zTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", zRegex)
        
        if zTest.evaluateWithObject(char){
            return 2
        }
        return 0
    }
    
    //这个函数很慢，所以最好是小数据活着存入时就把首字母存入
    class func firstCharactor(aString:String) -> String{
        
        //转成了可变字符串
        let str = NSMutableString(string: aString)
        //先转换为带声调的拼音
        CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false)
        //再转换为不带声调的拼音
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)
        //转化为大写拼音
        let pinYin = str.capitalizedString
        //获取并返回首字母
        return pinYin.substringToIndex(pinYin.startIndex.advancedBy(1))
        
    }
    
    //按首字母排序方法
    func sortPinYin(m1: AnyObject!, m2: AnyObject!) -> NSComparisonResult {
        let c1 = PinYinString.firstCharactor((m1 as! ContectorListModel).name)
        let c2 = PinYinString.firstCharactor((m2 as! ContectorListModel).name)
        if( c1 < c2){
            return NSComparisonResult.OrderedAscending
        }else{
            return NSComparisonResult.OrderedDescending
        }
    }
    
    //按首字母排序方法
    func sortString(m1: AnyObject!, m2: AnyObject!) -> NSComparisonResult {
        if ((m1 as! String) < (m2 as! String)){
            return NSComparisonResult.OrderedAscending
        }else{
            return NSComparisonResult.OrderedDescending
        }
    }
}