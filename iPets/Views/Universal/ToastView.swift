//
//  ToastView.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ToastView: NSObject{

    private var frameMarginSize: CGFloat! = 20 //文字左右间距
    private var frameSize:CGSize = CGSizeMake(Width-40, 60) //大小
    private var view: UIView!
    
    var textFont:CGFloat = 15 //字体大小
    var centerPosition : CGPoint = CGPoint(x: Width/2, y: Height-100)  //位置
    var duration : NSTimeInterval = 3
    var viewAlpha : CGFloat = 0.7
    
    //根据文字大小和数量，返回一个size
    func sizeWithString(string:NSString, font:UIFont)->CGSize {
        let dic:NSDictionary = NSDictionary(object: font, forKey: NSFontAttributeName)
        let options = NSStringDrawingOptions.TruncatesLastVisibleLine
        let rect:CGRect = string.boundingRectWithSize(frameSize, options:options, attributes: dic as? [String : AnyObject], context: nil)
        return rect.size
    }
    
    
    func showToast(text: String){
        
        let size:CGSize = self.sizeWithString(text, font: UIFont.systemFontOfSize(textFont))
        
        //显示的lable
        let label:UILabel = UILabel (frame: CGRectMake(0, 0, size.width, size.height))
        label.text = text
        label.font = UIFont.systemFontOfSize(textFont)
        label.numberOfLines = 0
        label.textColor = UIColor.whiteColor()
        
        //把toast加载到主窗口
        let window:UIWindow = UIApplication.sharedApplication().keyWindow!
        let v:UIButton = UIButton(frame:CGRectMake(0, 0, size.width + frameMarginSize, size.height + frameMarginSize))
        label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
        v.addSubview(label)
        
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: viewAlpha)
        v.layer.cornerRadius = 5
        v.center = CGPointMake(centerPosition.x, centerPosition.y+10)
        view = v
        
        v.addTarget(self, action: #selector(hideToast), forControlEvents: .TouchDown)
        window.addSubview(v) //用window加，保证最前
        //添加定时器，自动消失
        let timer:NSTimer = NSTimer(timeInterval: duration, target: self, selector: #selector(hideToast), userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
    
    @objc private func hideToast(){
        UIView.animateWithDuration(0.2, animations: {
            () -> ()in
            self.view.alpha = 0
            }, completion: {
                (Boolean) -> ()in
                self.view.removeFromSuperview()
        })
    }

}
