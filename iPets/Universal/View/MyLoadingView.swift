//
//  MyLoadingView.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MyLoadingView: UIView {

    fileprivate var targetView : UIView!
    fileprivate var activityIndicator : UIActivityIndicatorView!
    
    //显示风火轮
    func setLoading(_ targetView: UIView, color: UIColor){
        
        self.targetView = targetView
        
        self.frame.origin = CGPoint(x: self.targetView.width/2-15, y: self.targetView.height/2-30)
        self.frame.size = CGSize(width: 20, height: 20)
        
        //转圈的动画
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        
        activityIndicator.frame.origin = CGPoint(x: 0, y: 0)
        activityIndicator.color = color
        
        self.addSubview(activityIndicator)
    }
    
    func show(){
        self.targetView.addSubview(self)
        //开始动画
        activityIndicator.startAnimating()
    }
    
    func hide(){
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }

}
