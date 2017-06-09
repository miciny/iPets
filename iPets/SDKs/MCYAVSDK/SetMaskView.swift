//
//  SetMaskView.swift
//  MyNews
//
//  Created by maocaiyuan on 16/7/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Cartography

class SetMaskView: NSObject {

     /*
     // view : barView
     // playBtn
     // totalTimeLB
     // progressBar
     // fullScreenBtn
     // progressSlider
     */
    class func setBarView(_ view: UIView!, playBtn: UIButton!, totalTimeLB: UILabel!, progressBar: UIProgressView!, fullScreenBtn: UIButton!, progressSlider: UISlider!){
        //自己的约束
        view.clipsToBounds = true
        constrain(view) { (view) in
            let superView = view.superview!
            view.left == superView.left
            view.top == superView.bottom-44
            view.width == superView.width
            view.height == 44
        }
        
        //蒙层
        let blackView = UIView()
        blackView.backgroundColor = UIColor.black
        blackView.alpha = 0.7
        view.addSubview(blackView)
        //约束
        constrain(blackView) { (view) in
            let superView = view.superview!
            view.left == superView.left
            view.top == superView.top+1
            view.width == superView.width
            view.height == superView.height
        }
        
        //播放按钮
        playBtn.backgroundColor = UIColor.red
        view.addSubview(playBtn)
        //约束
        constrain(playBtn) { (view) in
            let superView = view.superview!
            view.left == superView.left
            view.top == superView.top+1
            view.width == 60
            view.height == 42
        }

        
        //总时间
        let timeSize = sizeWithText("88:88/88:88", font: videoTimeFont, maxSize: CGSize(width: Width, height: 44))
        totalTimeLB.font = videoTimeFont
        totalTimeLB.textColor = UIColor.white
        view.addSubview(totalTimeLB)
        //约束
        constrain(totalTimeLB, playBtn) { (view, view1) in
            let superView = view.superview!
            view.left == view1.right+5
            view.top == superView.top
            view.width == timeSize.width+5
            view.height == 44
        }
        
        view.addSubview(fullScreenBtn)
        //约束
        constrain(fullScreenBtn) { (view) in
            let superView = view.superview!
            view.right == superView.right
            view.top == superView.top+1
            view.width == 60
            view.height == 42
        }
        
        //缓冲条
        progressBar.progressTintColor = UIColor.darkGray
        progressBar.trackTintColor = UIColor.white
        view.addSubview(progressBar)
        //约束
        constrain(progressBar, fullScreenBtn, totalTimeLB) { (view, view1, view2) in
            let superView = view.superview!
            view.right == view1.left
            view.top == superView.centerY
            view.left == view2.right+10
            view.height == 2
        }
        
        //进度条
        progressSlider.minimumValue = Float(0)
        progressSlider.maximumValue = Float(100)
        progressSlider.setValue((0), animated: true)
        progressSlider.isContinuous = true // 设置是否连续触发事件，如果设为 false，在滑动过程中不触发，如果设为 true，在滑动过程中会连续触发
        view.addSubview(progressSlider)
        //约束
        constrain(progressSlider, fullScreenBtn, totalTimeLB) { (view, view1, view2) in
            let superView = view.superview!
            view.right == view1.left
            view.top == superView.top
            view.left == view2.right+10
            view.height == superView.height
        }
    }
    
    //全屏时返回的view
    class func setFullBackView(_ view: UIView!, backBtn: UIButton, backBtn1: UIButton, titleLb: UILabel?, titleStr: String?){
        //约束
        constrain(view) { (view) in
            let superView = view.superview!
            view.top == superView.top
            view.left == superView.left
            view.width == superView.width
            view.height == 50
        }
        
        //蒙层
        let blackView = UIView()
        blackView.backgroundColor = UIColor.black
        blackView.alpha = 0.7
        view.addSubview(blackView)
        //约束
        constrain(blackView) { (view) in
            let superView = view.superview!
            view.left == superView.left
            view.top == superView.top
            view.width == superView.width
            view.height == superView.height
        }
        
        //返回按钮
        backBtn.frame = CGRect(x: 0, y: 10, width: 40, height: 40)
        view.addSubview(backBtn)
        backBtn1.frame = CGRect(x: 10, y: 25, width: 21, height: 21)
        backBtn1.setImage(UIImage(named: "navigation_back"), for: .normal)
        view.addSubview(backBtn1)
        //约束
        constrain(backBtn, backBtn1) { (view, view1) in
            let superView = view.superview!
            view.left == superView.left
            view.top == superView.top+10
            view.height == 40
            view.width == 40
            
            view1.left == superView.left+10
            view1.top == superView.top+25
            view1.height == 21
            view1.width == 21
        }
        
        //标题
        if let titleStr = titleStr{
            if let titleLb = titleLb{
                let titleSizeT = sizeWithText("测试", font: videoTitleFont, maxSize: CGSize(width: Width, height: Height)) //高度
                let titleSize = sizeWithText(titleStr, font: videoTitleFont, maxSize: CGSize(width: Height - backBtn.maxXX - 50, height: Height)) //宽度
                titleLb.text = titleStr
                titleLb.textColor = UIColor.white
                titleLb.lineBreakMode = .byWordWrapping
                titleLb.font = videoTitleFont
                view.addSubview(titleLb)
                //约束
                constrain(titleLb, backBtn, backBtn1) { (view, view1, view2) in
                    view.left == view1.right
                    view.top == view2.top
                    view.height == titleSizeT.height
                    view.width ==  titleSize.width //获取不到view.width
                }
            }
        }
    }
    
    //调节音量的View
    class func setVolumeView(_ view: UIView!, volumeSlider: UISlider!){
        view.layer.borderWidth = 0.6
        view.layer.borderColor = UIColor.white.cgColor
        //约束
        constrain(view) { (view) in
            let superView = view.superview!
            view.centerX == superView.right - 45
            view.centerY == superView.centerY
            view.width == 40
            view.height == 170
        }
        
        let blackView = UIView()
        blackView.backgroundColor = UIColor.black
        blackView.alpha = 0.7
        view.addSubview(blackView)
        //约束
        constrain(blackView) { (view) in
            let superView = view.superview!
            view.left == superView.left
            view.top == superView.top
            view.width == superView.width
            view.height == superView.height
        }
        
        volumeSlider.maximumValue = 1
        volumeSlider.minimumValue = 0
        volumeSlider.maximumTrackTintColor = UIColor.lightGray
        volumeSlider.isContinuous = true // 设置是否连续触发事件，如果设为 false，在滑动过程中不触发，如果设为 true，在滑动过程中会连续触发
        view.addSubview(volumeSlider)
        //约束
        constrain(volumeSlider) { (view) in
            let superView = view.superview!
            view.center == superView.center
            view.width == 140
            view.height == 30
        }
        volumeSlider!.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi)/2)
    }
    
    //控制蒙层和蒙层的按钮
    class func setControllView(_ view: UIView, controlBtn: UIButton){
        view.clipsToBounds = true
        //约束
        constrain(view) { (view) in
            let superView = view.superview!
            view.center == superView.center
            view.width == superView.width
            view.height == superView.height
        }
        
        //控制按钮
        
        controlBtn.frame.origin = CGPoint(x: 0, y: 0)
        view.addSubview(controlBtn)
        //约束
        constrain(controlBtn) { (view) in
            let superView = view.superview!
            view.center == superView.center
            view.width == superView.width
            view.height == superView.height
        }
    }
    
    //关闭按钮
    class func setCloseBtn(_ view: UIButton){
        view.backgroundColor = UIColor.blue
        view.setImage(UIImage(named: "close_btn"), for: .normal)
        //约束
        constrain(view) { (view) in
            let superView = view.superview!
            view.top == superView.top
            view.right == superView.right
            view.width == 30
            view.height == 30
        }
    }
    
    //加载动画
    class func getLoadingIndicator(_ view: UIView) -> UIActivityIndicatorView{
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.white
        indicator.center = CGPoint(x: view.width/2, y: view.height/2)
        view.addSubview(indicator)
        return indicator
    }
}
