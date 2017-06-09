//
//  FindDataMaodel.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/9.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class FindDataModel: NSObject {
    
    var icon: String?
    var title: String
    var height: CGFloat
    
    init(title: String, icon: String?, height: CGFloat){
        self.title = title      //
        self.icon = icon        //
        self.height = height    //高度
    }
    
    //普通设置栏
    convenience init(icon: String?, title: String){
        let title = title
        let icon = icon
        let height = CGFloat(44)
        
        self.init(title: title, icon: icon, height: height)
    }
}
