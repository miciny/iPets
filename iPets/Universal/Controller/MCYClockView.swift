//
//  MCYClockView.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/14.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class MCYClockView: UIView {

    var position = CGPoint()//位置
    let length: CGFloat = 150  //大小
    let precision: TimeInterval = 8 //精度，每秒钟跳几次
    
    var hourNow = CGFloat()
    var minuteNow = CGFloat()
    var secondNow = CGFloat()
    var dateNow = String()
    
    var hourPointerView: UIView?
    var minutePointerView: UIView?
    var secondPointerView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        position = CGPoint(x: self.width/2, y: self.height/2)
        
        initTime()  //初始化时间
        setUpWatchDial()  //初始化表盘
        setUpHourPointer()  //初始化时针
        setUpMinutePointer()    //初始化分针
        setUpSecondPointer()    //初始化秒针
        startAnimation()    //开始动画
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //=====================================时间类===================================//
    //获取时分秒
    func initTime(){
        let timeNow = Date()
        hourNow = CGFloat(timeNow.getFormatDate(format: "HH"))
        minuteNow = CGFloat(timeNow.getFormatDate(format: "mm"))
        secondNow = CGFloat(timeNow.getFormatDate(format: "ss"))
        dateNow = String(timeNow.getFormatDate(format: "dd"))
    }
    
    
    //=====================================UI类===================================//
    //表盘
    func setUpWatchDial(){
        //装表的View
        let dialView = UIView()
        dialView.frame = CGRect(x: position.x-length, y: position.y-length, width: length*2, height: length*2)
        dialView.layer.cornerRadius = 10
        dialView.backgroundColor = UIColor.black
        self.addSubview(dialView)
        
        //表盘
        let dialLayer = CAShapeLayer()
        let startAngle: CGFloat = 0.0
        let endAngle: CGFloat = CGFloat(Double.pi * 2)
        let radius = length*4/5
        let path = UIBezierPath(arcCenter: position, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        dialLayer.path = path.cgPath
        dialLayer.fillColor = UIColor.white.cgColor
        dialLayer.strokeColor = UIColor.white.cgColor
        self.layer.addSublayer(dialLayer)
        
        //刻度
        let pointerLength = radius/20
        let pointerLengthR = radius - pointerLength
        for i in 0 ..< 60{
            let alphaC = (CGFloat(Double.pi * 2) / 60) * CGFloat(i) //每个刻度的角度
            let pointerLayer = CAShapeLayer()
            let bezier = UIBezierPath()
            
            var startX = position.x + sin(alphaC) * (pointerLengthR)
            var endX = position.x + sin(alphaC) * (radius)
            
            var startY = position.y + cos(alphaC) * (pointerLengthR)
            var endY = position.y + cos(alphaC) * (radius)
            
            if(i%5 == 0){ //如果是5，长一点
                startX = position.x + sin(alphaC) * (pointerLengthR-pointerLength*2)
                endX = position.x + sin(alphaC) * (radius)
                
                startY = position.y + cos(alphaC) * (pointerLengthR-pointerLength*2)
                endY = position.y + cos(alphaC) * (radius)
            }
            
            bezier.move(to: CGPoint(x: startX, y: startY))
            bezier.addLine(to: CGPoint(x: endX, y: endY))
            pointerLayer.path = bezier.cgPath
            pointerLayer.fillColor = UIColor.black.cgColor
            pointerLayer.strokeColor = UIColor.black.cgColor
            pointerLayer.lineWidth = 1
            self.layer.addSublayer(pointerLayer)
        }
        
        //表盘中心的点
        let circleLayer = CAShapeLayer()
        let startAngle1: CGFloat = 0.0
        let endAngle1: CGFloat = CGFloat(Double.pi * 2)
        let radius1 = length/30
        let path1 = UIBezierPath(arcCenter: position, radius: radius1, startAngle: startAngle1, endAngle: endAngle1, clockwise: true)
        circleLayer.path = path1.cgPath
        circleLayer.fillColor = UIColor.black.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
        self.layer.addSublayer(circleLayer)
        
        //日期
        let frameLine = UIView(frame: CGRect(x: position.x-10, y: position.y+radius*1/2, width: 20, height: 28))
        frameLine.backgroundColor = UIColor.white
        frameLine.layer.borderColor = UIColor.black.cgColor
        frameLine.layer.borderWidth = 1
        self.addSubview(frameLine)
        
        let dateLb = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 28))
        dateLb.textAlignment = .center
        dateLb.textColor = UIColor.black
        dateLb.text = dateNow
        dateLb.font = UIFont.systemFont(ofSize: 15)
        frameLine.addSubview(dateLb)
        
        //标语 图片
        let HamiltonLb = UILabel(frame: CGRect(x: position.x-30, y: position.y+radius*1/3, width: 60, height: 10))
        HamiltonLb.textAlignment = .center
        HamiltonLb.textColor = UIColor.black
        HamiltonLb.text = "AUTOMATIC"
        HamiltonLb.font = UIFont.systemFont(ofSize: 8)
        self.addSubview(HamiltonLb)
        
        let HamiltonPic = UIImageView(frame: CGRect(x: position.x-20, y: position.y-radius*2/3, width: 40, height: 40))
        HamiltonPic.backgroundColor = UIColor.red
        HamiltonPic.image = UIImage(named: "hamilton")
        self.addSubview(HamiltonPic)
    }
    
    //时针
    func setUpHourPointer(){
        let pointerLength = length*4/5
        let pointerWidth : CGFloat = 6
        hourPointerView = UIView()
        hourPointerView!.frame = CGRect(x: position.x-pointerWidth/2, y: position.y-pointerLength/2, width: pointerWidth, height: pointerLength)
        hourPointerView!.backgroundColor = UIColor.clear
        self.addSubview(hourPointerView!)
        
        let pointerLayer = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: pointerWidth/2, y: pointerLength/2))
        bezier.addLine(to: CGPoint(x: 0, y: pointerLength/4))
        bezier.addLine(to: CGPoint(x: pointerWidth/2, y: 0))
        bezier.addLine(to: CGPoint(x: pointerWidth, y: pointerLength/4))
        bezier.addLine(to: CGPoint(x: pointerWidth/2, y: pointerLength/2))
        pointerLayer.path = bezier.cgPath
        pointerLayer.fillColor = UIColor.black.cgColor
        pointerLayer.strokeColor = UIColor.black.cgColor
        pointerLayer.lineWidth = 1
        hourPointerView!.layer.addSublayer(pointerLayer)
    }
    
    //分针
    func setUpMinutePointer(){
        let pointerLength = length*7/5-5
        let pointerWidth : CGFloat = 5
        minutePointerView = UIView()
        minutePointerView!.frame = CGRect(x: position.x-pointerWidth/2, y: position.y-pointerLength/2, width: pointerWidth, height: pointerLength)
        minutePointerView!.backgroundColor = UIColor.clear
        self.addSubview(minutePointerView!)
        
        let pointerLayer = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: pointerWidth/2, y: pointerLength/2))
        bezier.addLine(to: CGPoint(x: 0, y: pointerLength/3))
        bezier.addLine(to: CGPoint(x: pointerWidth/2, y: 0))
        bezier.addLine(to: CGPoint(x: pointerWidth, y: pointerLength/3))
        bezier.addLine(to: CGPoint(x: pointerWidth/2, y: pointerLength/2))
        pointerLayer.path = bezier.cgPath
        pointerLayer.fillColor = UIColor.black.cgColor
        pointerLayer.strokeColor = UIColor.black.cgColor
        pointerLayer.lineWidth = 1
        minutePointerView!.layer.addSublayer(pointerLayer)
    }
    
    //秒针
    func setUpSecondPointer(){
        let pointerLength = length*7/5
        let pointerWidth : CGFloat = 4
        secondPointerView = UIView()
        secondPointerView!.frame = CGRect(x: position.x-pointerWidth/2, y: position.y-pointerLength/2, width: pointerWidth, height: pointerLength)
        secondPointerView!.backgroundColor = UIColor.clear
        self.addSubview(secondPointerView!)
        
        let pointerLayer = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: pointerWidth/2-0.5, y: pointerLength*7/12))
        bezier.addLine(to: CGPoint(x: pointerWidth/2-0.5, y: 0))
        bezier.addLine(to: CGPoint(x: pointerWidth/2+0.5, y: 0))
        bezier.addLine(to: CGPoint(x: pointerWidth/2+0.5, y: pointerLength*7/12))
        bezier.addLine(to: CGPoint(x: pointerWidth, y: pointerLength*7/12))
        bezier.addLine(to: CGPoint(x: pointerWidth/2, y: pointerLength*8/12))
        bezier.addLine(to: CGPoint(x: 0, y: pointerLength*7/12))
        bezier.addLine(to: CGPoint(x: pointerWidth/2-0.5, y: pointerLength*7/12))
        pointerLayer.path = bezier.cgPath
        pointerLayer.fillColor = UIColor.black.cgColor
        pointerLayer.strokeColor = UIColor.black.cgColor
        pointerLayer.lineWidth = 0.5
        secondPointerView!.layer.addSublayer(pointerLayer)
    }
    
    //=====================================动画类===================================//
    
    func startAnimation(){
        let secondNowOffset = secondNow/60*CGFloat(Double.pi*2)/60 // 秒钟起始位置/60
        let minuteNowOffset = (minuteNow/60*CGFloat(Double.pi*2)+secondNowOffset)/12 //分针的起始位置/12
        
        //分针的位置还得决定时针在那个格子里的偏移
        let animation1 = rotationAnimation(hourNow/12*CGFloat(Double.pi*2)+minuteNowOffset,speed: 60*60*12)
        hourPointerView!.layer.add(animation1, forKey: "animation1")
        
        //秒针的位置还得决定分针在那个格子里的偏移
        let animation2 = rotationAnimation(minuteNow/60*CGFloat(Double.pi*2)+secondNowOffset,speed: 60*60)
        minutePointerView!.layer.add(animation2, forKey: "animation2")
        
        let animation3 = rotationAnimation1(secondNow, speed: 60)
        secondPointerView!.layer.add(animation3, forKey: "animation3")
    }
    
    //自转动画 ,参数begin可以确定开始位置
    func rotationAnimation(_ begin: CGFloat, speed: CFTimeInterval) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = begin
        animation.toValue = begin + CGFloat(Double.pi*2)
        animation.duration = speed
        animation.autoreverses = false
        animation.repeatCount = 1/0
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        return animation
    }
    
    //关键帧的旋转动画
    func rotationAnimation1(_ beginSecond: CGFloat, speed: CFTimeInterval) -> CAKeyframeAnimation{
        let animation = CAKeyframeAnimation(keyPath: "transform")
        var rotation = [AnyObject]()
        for i in Int(beginSecond)*Int(precision) ..< Int((speed+CFTimeInterval(beginSecond))*precision) {
            let rotationTmp = CATransform3DMakeRotation(CGFloat(i)*CGFloat(Double.pi*2)/CGFloat(speed*precision), 0, 0, 1)
            rotation.append(NSValue(caTransform3D: rotationTmp))
        }
        animation.values = rotation
        animation.calculationMode = kCAAnimationDiscrete  // 只展示关键帧的状态，没有中间过程，没有动画,机械表的关键啊！！！
        animation.duration = speed
        animation.autoreverses = false
        animation.repeatCount = 1/0
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        return animation
    }
}

