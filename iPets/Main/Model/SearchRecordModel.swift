//
//  SearchRecord.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/15.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SearchRecordModel: NSObject {
    
    var record : String?
    var type: Int? //0代表title 2 代表底下晴空按钮
    
    init(record: String?, type: Int?) {
        self.record = record
        self.type = type
    }

}
