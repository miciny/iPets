//
//  UIViewExtension.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/21.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

///
/// @brief UIView的扩展方法，方便工程全局使用扩展方法来创建或者使用所有继承于UIView的控件
///
extension UIView {
    ///
    /// 获取或设置origin.x
    ///
    func originX() ->CGFloat {
        return self.frame.origin.x
    }
    
    func originX(_ originX: CGFloat) {
        var rect = self.frame
        rect.origin.x = originX
        self.frame = rect
    }
    
    ///
    /// 获取或设置origin.y
    ///
    func originY() ->CGFloat {
        return self.frame.origin.y
    }
    
    func originY(_ originY: CGFloat) {
        var rect = self.frame
        rect.origin.y = originY
        self.frame = rect
    }
    
    ///
    /// 获取或设置origin
    ///
    func origin() ->CGPoint {
        return self.frame.origin
    }
    
    func origin(_ origin: CGPoint) {
        var rect = self.frame
        rect.origin = origin
        self.frame = rect
    }
    
    ///
    /// 获取或设置width
    ///
    func getwidth() ->CGFloat {
        return self.frame.size.width
    }
    
    func width(_ width: CGFloat) {
        var rect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    
    ///
    /// 获取或设置height
    ///
    func getheight() ->CGFloat {
        return self.frame.size.height
    }
    
    func height(_ height: CGFloat) {
        var rect = self.frame
        rect.size.height = height
        self.frame = rect
    }
    
    ///
    /// 获取rightX
    ///
    func rightX() ->CGFloat {
        return originX() + getwidth()
    }
    
    ///
    /// 获取或设置bottomY
    ///
    func bottomY() ->CGFloat {
        return originY() + getheight()
    }
    
    func bottomY(_ bottomY: CGFloat) {
        var rect = self.frame
        rect.origin.y = bottomY - getheight()
        self.frame = rect
    }
}
