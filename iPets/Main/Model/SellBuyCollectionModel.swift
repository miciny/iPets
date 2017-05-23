//
//  CollectionModel.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/18.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

//每个collection中的cell的数据模型

class SellBuyCollectionModel: NSObject {
    var name : String?
    var picture : String?
    
    init(dic: NSDictionary) {
        self.name = dic.value(forKey: "name") as? String
        self.picture = dic.value(forKey: "pic") as? String
    }
    
}
