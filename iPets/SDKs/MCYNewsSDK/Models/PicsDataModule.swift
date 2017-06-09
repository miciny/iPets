//
//  PicsDataModule.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/21.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

//图集
class PicsDataModule: NSObject {
    var pic : String?
    var alt: String?
    var kpic: String?
    var width: Int?
    var height: Int?
    var gif : String?
    
    init(pic: String?, alt: String?, kpic: String?, width: Int?, height: Int?, gif: String?) {
        self.pic = pic
        self.alt = alt
        self.kpic = kpic
        self.width = width
        self.height = height
        self.gif = gif
    }
}
