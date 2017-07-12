//
//  Calculate.swift
//  Tetris
//
//  Created by maocaiyuan on 2017/1/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import AudioToolbox

class TetrisCalculate: NSObject {
    //传入两个数字，如1，3，作为坐标，返回0103, 因为button的tag不好标记位置
    class func setTag(_ i: Int, j: Int) -> Int{
        let a = String(i)
        let b = j<10 ? "0"+String(j) : String(j)
        let ab = a+b
        return Int(ab)!
    }
    
    //根据2030，返回一个[20, 30]
    class func getTag(_ position: Int) -> [Int]{
        let a = position / 100
        let b = position % 100
        return [a, b]
    }
    
    //获得一个随机整数 包含min 不包含max
    class func getRandomNo(_ min: Int, max: Int) -> Int{
        let array = probabilityController(min, max: max)
        
        let _min: UInt32 = 0
        let _max: UInt32 = UInt32((array.lastObject as AnyObject).lastObject as! Int) + 1
        let theNo = randomNo(_min, max: _max)  //随机到的编号
        log.info("随机编号：" + String(theNo))
        var theEleNo = 0
        for i in 0 ..< array.count{
            let a = array[i] as! NSMutableArray
            if a.contains(theNo){
                theEleNo = i + min // + min 是处理不是从0开始的情况
                break
            }
        }
        log.info("元素编号：" + String(theEleNo))
        return theEleNo
    }
    
    //随机一个数
    class func randomNo(_ min: UInt32, max: UInt32) -> Int{
        return Int(arc4random_uniform(max - min) + min)  //随机到的编号
    }
    
    //概率控制
    class func probabilityController(_ min: Int, max: Int) -> NSMutableArray{
        let array = NSMutableArray()
        var sum = 0
        
        for i in min ..< max {
            let no = probability[i]
            sum = sum + no
            
            let arrayT = NSMutableArray()
            for j in sum-no ..< sum{
                arrayT.add(j)
            }
            
            array.add(arrayT)
        }
        //    log.info(array)
        return array
    }
    
    //震动
    class func systemVibration() {
        //建立的SystemSoundID对象
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        //振动
        AudioServicesPlaySystemSound(soundID)
    }

}




