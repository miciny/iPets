//
//  ContectorListModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/29.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ContectorListViewDataModel: NSObject {
    var name: String
    var icon: UIImage?
    
    init(name: String, icon: UIImage?){
        self.name = name
        self.icon = icon
    }
}
