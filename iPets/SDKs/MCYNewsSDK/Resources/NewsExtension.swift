//
//  NewsExtension.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/9.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    //自定义的标签label样式
    public class func labelLabel(_ str: String, textColor: UIColor) -> UILabel{
        let label = UILabel()
        let labelSize = sizeWithText(str, font: newslabelFont, maxSize: CGSize(width: Width, height: Height))
        label.frame.size = CGSize(width: labelSize.width+5, height: labelSize.height+2)
        label.font = newslabelFont
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        label.textColor = textColor
        label.layer.cornerRadius = 3
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 0.8
        label.text = str
        return label
    }
    
    //自定义的红底白字view样式
    public class func headerLabelView(_ str: String) -> UIView{
        let myView = UIView()
        myView.backgroundColor = UIColor.red
        myView.layer.cornerRadius = 3
        
        let label = UILabel()
        let labelSize = sizeWithText(str, font: headerLabelFont, maxSize: CGSize(width: Width, height: Height))
        label.frame = CGRect(x: 0, y: 0, width: labelSize.width>40 ? labelSize.width : 40 , height: labelSize.height+2)
        label.font = headerLabelFont
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = str
        
        myView.frame.size = label.frame.size
        myView.addSubview(label)
        return myView
    }
    
    //自定义的评论label样式
    public class func commentLabel(_ str: String) -> UILabel{
        let label = UILabel()
        let labelSize = sizeWithText(str, font: newsCommentFont, maxSize: CGSize(width: Width, height: Height))
        label.frame.size = CGSize(width: labelSize.width, height: labelSize.height)
        label.font = newsCommentFont
        label.textColor = UIColor.lightGray
        label.text = str
        return label
    }
}
