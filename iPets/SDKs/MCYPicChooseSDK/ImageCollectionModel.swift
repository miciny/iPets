//
//  ImageCollectionModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/29.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Photos

class ImageCollectionModel: NSObject {
    var asset: UIImage!
    var isSelect: Bool = false
    
    override init() {
        super.init()
    }
}
