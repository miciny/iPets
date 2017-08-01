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
        let min: CGFloat = 18
        
        let font = UIFont.systemFont(ofSize: 12)
        let size = sizeWithText(str, font: font, maxSize: CGSize(width: 50, height: 50))
        
        let w = (size.width+1) < min ? min: size.width+6
        let h = (size.height+1) < min ? min : size.height
        
        v.frame.size = CGSize(width: w, height: h)
        v.layer.cornerRadius = h/2
        v.text = str
        v.clipsToBounds = true
        v.textColor = UIColor.white
        v.backgroundColor = UIColor.red
        v.font = font
        v.textAlignment = .center
        
        return v
    }
    
    class func redDotView(_ pi: CGFloat) -> UIView{
        
        let v = UIView()
        v.frame.size = CGSize(width: pi, height: pi)
        v.layer.cornerRadius = pi/2
        v.clipsToBounds = true
        v.backgroundColor = UIColor.red
        
        return v
    }
    
}
