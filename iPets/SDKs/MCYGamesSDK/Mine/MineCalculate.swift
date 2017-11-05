//
//  Calculate.swift
//  MineClearance
//
//  Created by maocaiyuan on 2017/1/19.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

class MineCalculate: NSObject {
    //传入两个数字，如1，3，作为坐标，返回0103, 因为button的tag不好标记位置
    class func mineSetTag(_ i: Int, j: Int) -> Int{
        let a = String(i)
        let b = j<10 ? "0"+String(j) : String(j)
        let ab = a+b
        return Int(ab)!
    }
    
    //根据2030，返回一个[20, 30]
    class func mineGetTag(_ position: Int) -> [Int]{
        let a = position / 100
        let b = position % 100
        return [a, b]
    }
    
    //设置一雷的位置，按坐标来setTag
    class func minePosition(_ count: Int) -> Int{
        let no = mineGetRandomNo(0, max: count*count)
        let x = no/count
        let y = no%count
        let position = mineSetTag(x, j: y)
        return position
    }
    
    //获得一个随机整数,包含min 不包含max
    class func mineGetRandomNo(_ min: Int, max: Int) -> Int{
        let _max: UInt32 = UInt32(max)
        let _min: UInt32 = UInt32(min)
        let theNo = Int(arc4random_uniform(_max - _min) + _min)
        return theNo
    }
    
    //根据坐标，返回【【Int】】，周围八个位置
    class func getAllRound(_ x: Int, y: Int) -> [[Int]]{
        //周围的八个位置
        let round = [[x-1, y-1], [x, y-1], [x+1, y-1],
                     [x-1, y],             [x+1, y],
                     [x-1, y+1], [x, y+1], [x+1, y+1]]
        return round
    }
    
    //根据文字获得大小
    class func sizeWithText(_ text: NSString, font: UIFont, maxSize: CGSize) -> CGSize{
        let attrs : NSDictionary = [NSAttributedStringKey.font:font]
        return text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin,
                                 attributes: attrs as? [NSAttributedStringKey : AnyObject], context: nil).size
    }
    
    //判断字符串为数字
    class func stringIsInt(_ str: String) -> Bool{
        let scan = Scanner(string: str)
        var i = Int32()
        return scan.scanInt32(&i) && scan.isAtEnd
    }
    

}
