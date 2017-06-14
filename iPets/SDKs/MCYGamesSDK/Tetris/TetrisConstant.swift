//
//  Constant.swift
//  Tetris
//
//  Created by maocaiyuan on 2017/1/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

//==============================================常量================================

var speed = downSpeed    //自动下降速度
let moveFastQueue = DispatchQueue(label: "move_fast")  //快速移动
var BGMAllowed = false  //背景音乐播放


//比较器，排序用
let tetrisGetSort = {(n1: Int, n2: Int) -> Bool in
    //进行从小到大的排序
    return n2 > n1
}
