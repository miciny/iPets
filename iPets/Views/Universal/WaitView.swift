//
//  WaitView.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class WaitView: UIView {
    //私有变量，不可改
    private var mask: UIControl! //把视图加到主窗口
    private var timer: NSTimer! //定时器，可以设置几秒后消失

    //可以修改，改变属性
    var viewAlpha : CGFloat = 1 //透明度
    var timeOut : NSTimeInterval = 30 //超时时长
    var centerPosition = CGPoint(x: Width/2, y: Height/2) //中点位置
    
    func showWait(title: String){
        
        //控制器
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10 //边角
        self.layer.borderColor = UIColor.clearColor().CGColor //边框颜色
        self.backgroundColor = UIColor.clearColor()  //背景色
        let position: CGPoint = self.center
        self.frame = CGRectMake(position.x-50, position.y-50, 100, 100)
        
        //view
        let tmpView = UIView(frame: CGRectMake(0, 0, 100, 100))
        tmpView.backgroundColor = UIColor.blackColor()
        tmpView.alpha = viewAlpha   //透明度
        tmpView.layer.masksToBounds = true
        tmpView.layer.cornerRadius = 10
        self.addSubview(tmpView)
        
        //转圈的动画
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.hidden = true
        activityIndicator.startAnimating()
        activityIndicator.center = CGPointMake(50, 50)
        self.addSubview(activityIndicator)
        
        //显示的文案
        let loadingLab = UILabel(frame: CGRectMake(0, 70, 100, 20));
        loadingLab.backgroundColor = UIColor.clearColor();
        loadingLab.textAlignment = NSTextAlignment.Center
        loadingLab.textColor = UIColor.whiteColor()
        loadingLab.font = UIFont.systemFontOfSize(15)
        loadingLab.text = title
        self.addSubview(loadingLab)
        
        // 添加超时定时器
        timer = NSTimer(timeInterval: timeOut, target: self, selector: #selector(WaitView.timerDeadLine), userInfo: nil, repeats: false)
        
        //显示toast的View
        if mask==nil {
            mask = UIControl(frame: UIScreen.mainScreen().bounds)
            mask.backgroundColor = UIColor.clearColor()
            mask.addSubview(self)
            UIApplication.sharedApplication().keyWindow?.addSubview(mask)
            self.center = CGPoint(x: centerPosition.x, y: centerPosition.y)
            mask.alpha = 1
        }
        mask.hidden = false
        
        // 添加定时器
        if timer != nil {
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        }
        WaitView.showNetIndicator() //显示网络加载状态
    }
    
    //请求超时时显示
    @objc private func timerDeadLine(){
        self.hideView()
        WaitView.makeToast("请求超时")
    }
    
    //隐藏
    func hideView() {
        if NSThread.currentThread().isMainThread{
            self.removeView()
        }else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.removeView()
            })
        }
        WaitView.hidenNetIndicator()  //移除网络加载状态
    }
    
    //移除view
    private func removeView(){
        if mask != nil {
            mask.hidden = true
            timer.invalidate()
        }
    }
    
    //这个用法可以学习，显示toast
    class func makeToast(strTitle:String) {
        NSThread.sleepForTimeInterval(0.3)
        let toast = ToastView()
        if NSThread.currentThread().isMainThread{
            toast.showToast(strTitle)
        }else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                toast.showToast(strTitle)
            })
        }
    }
    
    //系统栏的转圈动画
    class func showNetIndicator(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    class func hidenNetIndicator(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    

}
