//
//  loaaaa.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/8.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

//加载图片时的动画
class LoadingPicView: UIView {
    
    fileprivate var innerLine: CAShapeLayer?
    
    func setView(_ targetView: UIView){
        self.frame.size = CGSize(width: 50, height: 50)
        self.backgroundColor = UIColor.clear
        targetView.addSubview(self)
        self.isHidden = true
        self.center = CGPoint(x: targetView.width/2, y: targetView.height/2)
        
        drawOuterView()
        drawInnerView()
    }
    
    //外部线
    func drawOuterView(){
        let startAngle: CGFloat = 0.0
        let endAngle: CGFloat = CGFloat(Double.pi*2)
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = self.frame.width/2 - 1
        
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let outerLine = CAShapeLayer()
        outerLine.frame = self.bounds
        outerLine.path = path.cgPath
        outerLine.fillColor = UIColor.clear.cgColor
        outerLine.strokeColor = UIColor.white.cgColor
        
        self.layer.addSublayer(outerLine)
        self.layer.masksToBounds = true
    }
    
    //内部线
    func drawInnerView(){
        
        if innerLine != nil {
            innerLine?.removeFromSuperlayer()
            innerLine = nil
        }
        
        let innerRadius = self.frame.width/2 - 4
        
        let startAngle: CGFloat = CGFloat(-Double.pi/2)
        let endAngle: CGFloat = CGFloat(Double.pi*3/2)
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: innerRadius/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        innerLine = CAShapeLayer()
        innerLine?.strokeEnd = 0
        innerLine?.strokeStart = 0
        innerLine?.lineWidth = innerRadius
        innerLine!.path = path.cgPath
        innerLine!.fillColor = UIColor.clear.cgColor
        innerLine!.strokeColor = UIColor.white.cgColor
        
        self.layer.addSublayer(innerLine!)
        self.layer.masksToBounds = true
    }
    
    func show(){
        self.isHidden = false
    }
    
    func hide(){
        UIView.animate(withDuration: 0, animations: {
            () -> ()in
            self.alpha = 0
        }, completion: {
            (Boolean) -> ()in
            self.removeFromSuperview()
        })
    }
    
    func setValue(_ value: Float){
        innerLine?.strokeEnd = CGFloat(value)
    }
    
}
