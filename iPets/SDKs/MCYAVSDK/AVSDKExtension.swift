//
//  Extension.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/8.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

//视频
let videoTimeFont = UIFont.systemFont(ofSize: standardFontNo-5) //视频时间的字体大小
let videoRuntimeFont = UIFont.systemFont(ofSize: standardFontNo-2) //的字体大小
let videoTitleFont = UIFont.systemFont(ofSize: standardFontNo+2) //title的字体大小

extension UIView {
    
    //自定义的黑底白字view样式
    public class func labelView(_ str: String) -> UIView{
        let myView = UIView()
        myView.backgroundColor = UIColor.clear
        myView.layer.cornerRadius = 3
        
        let myBlackView = UIView()
        myBlackView.backgroundColor = UIColor.black
        myBlackView.alpha = 0.4
        myBlackView.layer.cornerRadius = 3
        myView.addSubview(myBlackView)
        
        let label = UILabel()
        let labelSize = sizeWithText(str, font: videoRuntimeFont, maxSize: CGSize(width: Width, height: Height))
        label.frame = CGRect(x: 0, y: 0, width: labelSize.width>40 ? labelSize.width : 40 , height: labelSize.height)
        label.font = videoRuntimeFont
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = str
        
        myBlackView.frame = label.frame
        myView.frame.size = label.frame.size
        myView.addSubview(label)
        return myView
    }
    
    //=======================================坐标相关===========================================
    var x : CGFloat{
        return self.frame.minX
    }
    
    var y : CGFloat{
        return self.frame.minY
    }
    
    var maxXX : CGFloat{
        return self.frame.maxX
    }
    
    var maxYY : CGFloat{
        return self.frame.maxY
    }
    
    var centerXX: CGFloat{
        return self.frame.midX
    }
    
    var centerYY: CGFloat{
        return self.frame.midY
    }
    
    var width: CGFloat{
        return self.frame.width
    }
    
    var height: CGFloat{
        return self.frame.height
    }
}


extension UIColor{
    //cell图片的背景色
    public class func cellPicBackColor() -> UIColor{
        return UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
    }
}


extension UIImageView{
    //cell中那种，截取 灰色背景
    public class func cellPicView() -> UIImageView{
        let picView = UIImageView()
        picView.backgroundColor = UIColor.cellPicBackColor()
        picView.contentMode = .scaleAspectFill
        picView.clipsToBounds = true
        return picView
    }
}
