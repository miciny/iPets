//
//  UniversalFuncs.swift
//  iPets
//
//  Created by maocaiyuan on 2017/5/19.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

//字符串转成json
func strToJson(_ str: String) -> AnyObject{
    let data = str.data(using: String.Encoding.utf8)
    
    let deserialized = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
    return deserialized as AnyObject
}



//======================================根据nickname获得头像，指获取一个时使用================================
func getUserIcon(nickname: String) -> UIImage?{
    
    let contectors = SQLLine.SelectAllData(entityNameOfContectors)
    for c in contectors{
        let n = (c as! Contectors).nickname! as String
        if nickname == n{
            let iconData = (c as! Contectors).icon! as Data
            let icon = ChangeValue.dataToImage(iconData)
            return icon
        }
    }
    
    return nil
}



//======================================延迟执行方法================================

// delay(2) { print("2 秒后输出") }
// let task = delay(5) { print("拨打 110") }
// cancelTask(task)

typealias Task = (_ cancel : Bool) -> Void

func delay(_ time: TimeInterval, task: @escaping ()->()) -> Task? {
    
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (()->Void)? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

func cancelTask(_ task: Task?) {
    task?(true)
}




//======================================二维码================================

//通过string 和 一个图片 创建一个二维码
func createQRForString(_ qrString: String?, qrImage: UIImage?) -> UIImage?{
    
    if let sureQRString = qrString {
        let stringData = sureQRString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        // 创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter!.setValue(stringData, forKey: "inputMessage")
        qrFilter!.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter!.outputImage
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter!.setDefaults()
        colorFilter!.setValue(qrCIImage, forKey: "inputImage")
        colorFilter!.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter!.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        // 返回二维码image
        let codeImage = UIImage(ciImage: colorFilter!.outputImage!.applying(CGAffineTransform(scaleX: 5, y: 5)))
        
        // 通常,二维码都是定制的,中间都会放想要表达意思的图片
        if let iconImage = qrImage {
            let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
            UIGraphicsBeginImageContext(rect.size)
            
            codeImage.draw(in: rect)
            let avatarSize = CGSize(width: rect.size.width * 0.25, height: rect.size.height * 0.25)
            let x = (rect.width - avatarSize.width) * 0.5
            let y = (rect.height - avatarSize.height) * 0.5
            iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            return resultImage
        }
        return codeImage
    }
    return nil
}



//根据文字获得大小
func sizeWithText(_ text: String, font: UIFont, maxSize: CGSize) -> CGSize{
    let attrs : NSDictionary = [NSFontAttributeName:font]
    return text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin,
                             attributes: attrs as? [String : AnyObject], context: nil).size
}

//获得一个随机数
func getIntRandomNum(_ max: Int, min: Int) -> Int {
    guard max > min else {
        return 0
    }
    
    let max: UInt32 = UInt32(max)
    let min: UInt32 = UInt32(min)
    return Int(arc4random_uniform(max - min) + min)
}
