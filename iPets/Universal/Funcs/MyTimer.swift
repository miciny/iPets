//
//  MyTimer.swift
//  iPets
//
//  Created by maocaiyuan on 2017/5/25.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation

class MyTimer: NSObject {
    
    var timer: Timer!
    
    func setTimer(interval ti: TimeInterval, target t: Any, selector s: Selector, repeats rep: Bool){
        
        let ti = ti
        let t = t
        let s = s
        let rep = rep
        
        self.timer = Timer.scheduledTimer(timeInterval: ti, target: t, selector: s, userInfo: nil, repeats: rep)
    }
    
    //暂停计时器
    func pauseTimer(){
        self.timer.fireDate = Date.distantFuture //相当于暂停
    }
    
    func startTimer(interval ti: TimeInterval){
        self.timer.fireDate = Date().addingTimeInterval(ti)  //Ns后执行
    }
    
    //停止
    func stopTimer() {
        self.timer.invalidate()
    }
}
