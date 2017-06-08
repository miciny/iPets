//
//  WaitView.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class WaitView: UIControl {
    fileprivate var timer: Timer! //定时器，可以设置几秒后消失

    //可以修改，改变属性
    var viewAlpha: CGFloat = 1 //透明度
    var timeOut: TimeInterval = 30 //超时时长
    var centerPosition = CGPoint(x: Width/2, y: Height/2) //中点位置
    
    func showWait(_ title: String){
        
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.clear
        UIApplication.shared.keyWindow?.addSubview(self)
        self.center = CGPoint(x: centerPosition.x, y: centerPosition.y)
        self.alpha = 1
        
        //控制器
        let mainView = UIView()
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 10 //边角
        mainView.layer.borderColor = UIColor.clear.cgColor //边框颜色
        mainView.backgroundColor = UIColor.clear  //背景色
        mainView.frame = CGRect(x: self.center.x-50, y: self.center.y-50, width: 100, height: 100)
        self.addSubview(mainView)
        
        //view
        let tmpView = UIView(frame: CGRect(x: 0, y: 00, width: 100, height: 100))
        tmpView.backgroundColor = UIColor.black
        tmpView.alpha = viewAlpha   //透明度
        tmpView.layer.masksToBounds = true
        tmpView.layer.cornerRadius = 10
        mainView.addSubview(tmpView)
        
        //转圈的动画
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: 50, y: 50)
        mainView.addSubview(activityIndicator)
        
        //显示的文案
        let loadingLab = UILabel(frame: CGRect(x: 0, y: 70, width: 100, height: 20));
        loadingLab.backgroundColor = UIColor.clear;
        loadingLab.textAlignment = NSTextAlignment.center
        loadingLab.textColor = UIColor.white
        loadingLab.font = UIFont.systemFont(ofSize: 15)
        loadingLab.text = title
        mainView.addSubview(loadingLab)
        
        // 添加超时定时器
        timer = Timer(timeInterval: timeOut, target: self, selector: #selector(WaitView.timerDeadLine), userInfo: nil, repeats: false)
        // 添加定时器
        if timer != nil {
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
        WaitView.showNetIndicator() //显示网络加载状态
    }
    
    //请求超时时显示
    @objc fileprivate func timerDeadLine(){
        self.hideView()
        WaitView.makeToast("请求超时")
    }
    
    //隐藏
    func hideView() {
        if Thread.current.isMainThread{
            self.removeView()
        }else {
            mainQueue.async(execute: { () -> Void in
                self.removeView()
            })
        }
        WaitView.hidenNetIndicator()  //移除网络加载状态
    }
    
    //移除view
    fileprivate func removeView(){
        self.removeFromSuperview()
        timer.invalidate()
    }
    
    //这个用法可以学习，显示toast
    class func makeToast(_ strTitle:String) {
        Thread.sleep(forTimeInterval: 0.3)
        let toast = ToastView()
        if Thread.current.isMainThread{
            toast.showToast(strTitle)
        }else {
            mainQueue.async(execute: { () -> Void in
                toast.showToast(strTitle)
            })
        }
    }
    
    //系统栏的转圈动画
    class func showNetIndicator(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    class func hidenNetIndicator(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    

}
