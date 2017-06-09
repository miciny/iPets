//
//  VideoSlider.swift
//  MyNews
//
//  Created by maocaiyuan on 16/7/8.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class VideoSlider: UISlider{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSlider()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSlider(){
        self.setThumbImage(UIImage(named: "video_processView"), for: .normal)
        self.minimumTrackTintColor = UIColor.red
        self.maximumTrackTintColor = UIColor.clear

    }

    //重新设置触摸大小，原先太小了
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        var aRect = CGRect()
        aRect.origin.x = rect.origin.x-5
        aRect.size.width = rect.size.width+10
        
        aRect.origin.y = rect.origin.y
        aRect.size.height = rect.size.height
        
        let aa = super.thumbRect(forBounds: bounds, trackRect: aRect, value: value)
        let aRectInset = aa.insetBy(dx: 5, dy: 0)
        
        return aRectInset
    }
}
