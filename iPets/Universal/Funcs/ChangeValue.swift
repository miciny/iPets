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
    class func imageToData(_ image: UIImage) -> Data? {
        
        if let imageData = UIImageJPEGRepresentation(image, 1.0){
            print("图片转为DATA成功")
            return imageData
        }else{
            if let imageData = UIImagePNGRepresentation(image){
                print("图片转为DATA成功")
                return imageData
            }else{
                print("图片转为DATA失败")
                return nil
            }
        }
    }
    
}
