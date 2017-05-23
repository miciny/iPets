//
//  ChangeValue.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ChangeValue: NSObject {

    //nsdata转为image
    class func dataToImage(_ data: Data) -> UIImage {
        let image = UIImage(data: data)
        if(image == nil){
            return UIImage(named: "defaultIcon")!
        }
        return image!
    }
    
    //image转为nsdata
    class func imageToData(_ image: UIImage) -> Data {
        let imageData = UIImagePNGRepresentation(image)
        return imageData!
    }
    
}
