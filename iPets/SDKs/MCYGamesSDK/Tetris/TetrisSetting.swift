//
//  File.swift
//  Tetris
//
//  Created by maocaiyuan on 2017/2/22.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

let gap = CGFloat(13)  //格子大小
let downSpeed = TimeInterval(0.63)    //自动下降速度
let BGC = UIColor.black  //整体背景颜色

// 0竖条4个, 1田, 2右z, 3左z, 4土, 5左L, 6右L， 7折 ，8点, 9半框，10大土, 
//11条3个,12大山 , 13大大山， 14大框 , 15 H ,16十字， 17米字， 18半米字, 19斜的4个， 20 斜的3个
// 21 F1 , 22 F2()颜色不一样, 23 I2 , 24 I5

let minE = 0 //可以控制显示的元素类型
let maxE = 25 //一共几个元素

//概率，不一定要加起来100%
let probability0 = 8
let probability1 = 5
let probability2 = 7
let probability3 = 7
let probability4 = 5
let probability5 = 5
let probability6 = 5
let probability7 = 4
let probability8 = 3
let probability9 = 5
let probability10 = 0   //作废
let probability11 = 5
let probability12 = 0   //作废
let probability13 = 0   //作废
let probability14 = 0   //作废
let probability15 = 4
let probability16 = 0   //规则需要，不随机
let probability17 = 3
let probability18 = 0   //规则需要，不随机
let probability19 = 0   //作废
let probability20 = 3
let probability21 = 3
let probability22 = 3
let probability23 = 3
let probability24 = 3


let probability = [probability0,
                   probability1,
                   probability2,
                   probability3,
                   probability4,
                   probability5,
                   probability6,
                   probability7,
                   probability8,
                   probability9,
                   probability10,
                   probability11,
                   probability12,
                   probability13,
                   probability14,
                   probability15,
                   probability16,
                   probability17,
                   probability18,
                   probability19,
                   probability20,
                   probability21,
                   probability22,
                   probability23,
                   probability24
]




let ele0Color = UIColor(red: 0/255, green: 139/255, blue: 139/255, alpha: 1)
let ele1Color = UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1)
let ele2Color = UIColor(red: 122/255, green: 103/255, blue: 238/255, alpha: 1)
let ele3Color = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1)

let ele4Color = UIColor(red: 148/255, green: 0/255, blue: 211/255, alpha: 1)
let ele5Color = UIColor(red: 238/255, green: 44/255, blue: 44/255, alpha: 1)
let ele6Color = UIColor(red: 255/255, green: 20/255, blue: 147/255, alpha: 1)
let ele7Color = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)

let ele8Color = UIColor(red: 205/255, green: 85/255, blue: 85/255, alpha: 1)
let ele9Color = UIColor(red: 139/255, green: 101/255, blue: 8/255, alpha: 1)
let ele10Color = UIColor(red: 139/255, green: 139/255, blue: 20/255, alpha: 1)//作废
let ele11Color = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1)

let ele12Color = UIColor(red: 125/255, green: 38/255, blue: 205/255, alpha: 1)//作废
let ele13Color = UIColor(red: 54/255, green: 100/255, blue: 139/255, alpha: 1)//作废
let ele14Color = UIColor(red: 16/255, green: 78/255, blue: 139/255, alpha: 1)//作废
let ele15Color = UIColor(red: 0/255, green: 238/255, blue: 118/255, alpha: 1)

let ele16Color = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1)
let ele17Color = UIColor(red: 255/255, green: 20/255, blue: 147/255, alpha: 1)
let ele18Color = UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1)
let ele19Color = UIColor(red: 139/255, green: 87/255, blue: 66/255, alpha: 1)//作废

let ele20Color = UIColor(red: 58/255, green: 95/255, blue: 205/255, alpha: 1)
let ele21Color = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
let ele22Color = UIColor(red: 47/255, green: 79/255, blue: 79/255, alpha: 1)
let ele23Color = UIColor(red: 125/255, green: 38/255, blue: 205/255, alpha: 1)

let ele24Color = UIColor(red: 54/255, green: 100/255, blue: 139/255, alpha: 1)
