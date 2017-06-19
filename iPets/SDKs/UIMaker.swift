//
//  UIMaker.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/21.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

class UIMaker {
    ///
    /// @brief 生成按钮
    ///
    class func button(_ imageName: String, target: AnyObject?, action: Selector) ->UIButton {
        let img = UIImage(named: imageName)
        let button = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: img!.size.width, height: img!.size.height)
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        return button
    }
    
    ///
    /// @brief 生成标签
    ///
    class func label(_ frame: CGRect, title: String?) ->UILabel {
        let label = UILabel(frame: frame)
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.text = title
        
        return label
    }
}

