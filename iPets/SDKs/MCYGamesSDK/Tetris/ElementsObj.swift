//
//  ElementsObj.swift
//  Tetris
//
//  Created by maocaiyuan on 2017/2/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

//旋转样式 2代表两个方向，4代表4个方向, no代表不用转
enum dirModules {
    case two
    case four
    case no
}

//游戏中 暂停 结束
enum gameType{
    case pausing
    case gaming
    case gameOver
}

//元素属性，如穿透 爆炸
enum eleFunction{
    case invisible
    case boom
    case nothing
}


class ElementsObj: NSObject {
    var elePoint: [[Int]]!  // 元素点
    var ceterPonintNo: Int!  //
    var dirNo: dirModules! // 旋转样式
    var eleFunction: eleFunction! //是否是可以穿透的，目前只有点可以
    var color: UIColor! //颜色
    
    init(elePoint: [[Int]]!, ceterPonintNo: Int, dirNo: dirModules!, eleFunction: eleFunction!, color: UIColor) {
        self.ceterPonintNo = ceterPonintNo
        self.elePoint = elePoint
        self.dirNo = dirNo
        self.eleFunction = eleFunction
        self.color = color
    }
}
