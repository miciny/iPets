//
//  RollConstans.swift
//  iPets
//
//  Created by maocaiyuan on 2017/7/7.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class RollConstans: NSObject {
    //==============================================设置================================
    static let manArray = ["国德娟","冯彬羽","毛彩元","彭强强","常蒙蒙","陈晓萌",
                    "霍紫阳","陈泽群","娜仁格日乐","彭月","咸赫男","魏飞翔","杨骞","张雪","于力海"]  //
    static let manNoArrar = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
    static let manNotInclude = [100]  //人员
    

    static var standardFontNo = CGFloat(15)
    static var standardFont = UIFont.systemFont(ofSize: standardFontNo) //标准字体大小
    static var noFont = UIFont.boldSystemFont(ofSize: standardFontNo+10) //字体大小
    static var pageTitleFont = UIFont.boldSystemFont(ofSize: standardFontNo+3) //页面title的字体大小
    
    static var _width = (Width - 70) / 4  //图片大小
}
