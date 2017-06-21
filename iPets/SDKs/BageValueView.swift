//
//  BageValueView.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/21.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class BageValueView: NSObject {
    
    class func nbView(str: String) -> UIView{
        let v = UILabel()
        let min: CGFloat = 12
        
        let font = UIFont.systemFont(ofSize: 10)
        let size = sizeWithText(str, font: font, maxSize: CGSize(width: 20, height: 20))
        
        let w = (size.width+1) < min ? min: size.width+1
        let h = (size.height+1) < min ? min : size.height+1
        
        v.frame.size = CGSize(width: w, height: h)
        v.layer.cornerRadius = 8
        v.text = str
        v.textColor = UIColor.white
        v.backgroundColor = UIColor.red
        v.font = font
        v.textAlignment = .center
        
        return v
    }
    
}
