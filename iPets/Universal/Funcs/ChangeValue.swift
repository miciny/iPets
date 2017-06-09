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
    
    //视频时长转为时分秒显示
    class func runtimeToDate(_ runtime: Int) -> String{
        
        let sTemp = runtime/1000
        
        let h = sTemp/3600
        let m = (sTemp%3600)/60
        let s = ((sTemp%3600)%60)
        
        let hStr = h>9 ? "\(h)" : "0\(h)"
        let mStr = m>9 ? "\(m)" : "0\(m)"
        let sStr = s>9 ? "\(s)" : "0\(s)"
        
        return hStr=="00" ? mStr + ":" + sStr : hStr + ":" + mStr + ":" + sStr
    }
    
    //视频时长转为时分秒显示
    class func timeToDate(_ time: TimeInterval) -> String{
        let runtime = Int(time*1000)
        return runtimeToDate(runtime)
    }
    
}
