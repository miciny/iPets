//
//  VideoFuncs.swift
//  MyNews
//
//  Created by maocaiyuan on 16/7/7.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoFuncs: NSObject {
    
    //确认屏幕方向，如果0，是竖屏，如果1，是横屏, 如果2，不管
    class func checkScreenOrientation() -> Int{
        
        let device = UIDevice.current
        switch device.orientation{
        case .portrait:
            return 0
        case .landscapeLeft:
            return 1
        case .landscapeRight:
            return 1
        default:
            return 2
        }
    }
    
    //顶部系统栏
    class func setStatusBar(_ hide: Bool){
        UIApplication.shared.isStatusBarHidden = hide
    }
    
    //消失动画
    class func barDismissAnimation(_ fromValue: CGPoint, toValue: CGPoint) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: fromValue)
        animation.toValue = NSValue(cgPoint: toValue)
        animation.duration = 1
        
        return animation
    }
    
    //获得系统音量的slider
    class func getSystemVolumeSlider() -> UISlider?{
        var volumeViewSlider: UISlider?
        
        let volumeView = MPVolumeView()
        for newView in volumeView.subviews{
            if newView.isKind(of: UISlider.self){
                let volumeS = newView as? UISlider
                volumeViewSlider = volumeS
                volumeViewSlider!.sendActions(for: .touchUpInside)
            }
        }
        return volumeViewSlider
    }
    
    //界面消失，停止视频
    class func viewWillDisappearStopVideo(){
        if videoPlayer.isPlayed == true{
            videoPlayer.stop()
        }
    }
    
    //cell滑出屏幕时，结束播放
    class func cellWillDisappearStopVideo(_ indexPath: IndexPath){
        if videoPlayer.indexPath != nil {
            if videoPlayer.indexPath == indexPath{
                if videoPlayer.isPlayed == true{
                    videoPlayer.stop()
                }
            }
        }
    }
}
