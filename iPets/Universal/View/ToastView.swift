//
//  ToastView.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ToastView: NSObject{

    fileprivate var frameMarginSize: CGFloat! = 20 //文字左右间距
    fileprivate var frameSize:CGSize = CGSize(width: Width-40, height: 60) //大小
    fileprivate var view: UIView!
    
    var textFont: CGFloat = 15 //字体大小
    var centerPosition: CGPoint = CGPoint(x: Width/2, y: Height-100)  //位置
    var duration: TimeInterval = 3
    var viewAlpha: CGFloat = 0.7
    
    //根据文字大小和数量，返回一个size
    func sizeWithString(_ string:NSString, font:UIFont)->CGSize {
        let dic:NSDictionary = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let options = NSStringDrawingOptions.truncatesLastVisibleLine
        let rect:CGRect = string.boundingRect(with: frameSize, options:options, attributes: dic as? [String : AnyObject], context: nil)
        return rect.size
    }
    
    
    func showToast(_ text: String){
        
        let size:CGSize = self.sizeWithString(text as NSString, font: UIFont.systemFont(ofSize: textFont))
        
        //显示的lable
        let label:UILabel = UILabel (frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.text = text
        label.font = UIFont.systemFont(ofSize: textFont)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        
        //把toast加载到主窗口
        let window:UIWindow = UIApplication.shared.keyWindow!
        let v:UIButton = UIButton(frame:CGRect(x: 0, y: 0, width: size.width + frameMarginSize, height: size.height + frameMarginSize))
        label.center = CGPoint(x: v.frame.size.width / 2, y: v.frame.size.height / 2);
        v.addSubview(label)
        
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: viewAlpha)
        v.layer.cornerRadius = 5
        v.center = CGPoint(x: centerPosition.x, y: centerPosition.y+10)
        view = v
        
        v.addTarget(self, action: #selector(hideToast), for: .touchDown)
        window.addSubview(v) //用window加，保证最前
        //添加定时器，自动消失
        let timer:Timer = Timer(timeInterval: duration, target: self, selector: #selector(hideToast), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    @objc fileprivate func hideToast(){
        UIView.animate(withDuration: 0.2, animations: {
            () -> ()in
            self.view.alpha = 0
            }, completion: {
                (Boolean) -> ()in
                self.view.removeFromSuperview()
        })
    }

}
