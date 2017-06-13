//
//  ControllerView.swift
//  Tetris
//
//  Created by maocaiyuan on 2017/1/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

//移动变形操作协议
protocol controllerViewDelegate{
    
    func moveRight() //点击向右的协议
    
    func moveLeft() //左
    
    func pauseGame() //大按钮 暂停
    
    func transform() //变形
    
    func moveDownFast() //快速下
}

class ControllerView: UIView {
    
    fileprivate var delegate : controllerViewDelegate?
    fileprivate var size = CGFloat(70)
    fileprivate var originSpeed : TimeInterval = 0 //记录原先的速度
    fileprivate var doingFastMove = Bool() //是否快速左右移动
    fileprivate var longPressTime = 0.2 //定义按的时间

    init(frame: CGRect, delegate: controllerViewDelegate) {
        super.init(frame: frame)
        self.backgroundColor = BGC
        self.delegate = delegate
        
        self.setUpView()
    }
    
    func setUpView(){
        let _height = self.frame.height
        let gapX = CGFloat(10)
        
        let leftBtn = self.myBtn("L", origin: CGPoint(x: gapX, y: _height/2-size/2))
        leftBtn.addTarget(self, action: #selector(moveLeft), for: .touchDown)
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(autoMoveLeft))
        longPress.minimumPressDuration = longPressTime //定义按的时间
        leftBtn.addGestureRecognizer(longPress)
        self.addSubview(leftBtn)
        
        let upBtn = self.myBtn("U", origin: CGPoint(x: gapX+size, y: _height/2-size*4/3))
        upBtn.addTarget(self, action: #selector(transformEle), for: .touchDown)
        self.addSubview(upBtn)
        
        let rightBtn = self.myBtn("R", origin: CGPoint(x: gapX+2*size, y: _height/2-size/2))
        rightBtn.addTarget(self, action: #selector(moveRight), for: .touchDown)
        let longPress1 = UILongPressGestureRecognizer.init(target: self, action: #selector(antoMoveRight))
        longPress1.minimumPressDuration = longPressTime //定义按的时间
        rightBtn.addGestureRecognizer(longPress1)
        self.addSubview(rightBtn)
        
        let downBtn = self.myBtn("D", origin: CGPoint(x: gapX+size, y: _height/2+size/3))
        downBtn.addTarget(self, action: #selector(moveDown), for: .touchDown)
        downBtn.addTarget(self, action: #selector(cancelMoveDown), for: .touchUpInside)
        self.addSubview(downBtn)
        
        let bigBtn = self.myBtn("P/S", origin: CGPoint(x: Width-size-gapX*3, y: _height/2-size/2))
        bigBtn.addTarget(self, action: #selector(pauseGame), for: .touchDown)
        self.addSubview(bigBtn)
    }
    
    //按钮样式
    fileprivate func myBtn(_ title: String, origin: CGPoint) -> UIButton{
        let btn = UIButton()
        btn.frame.size = CGSize(width: size, height: size)
        btn.frame.origin = origin
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = size/2
        btn.backgroundColor = UIColor.lightGray
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setTitleColor(UIColor.white, for: .highlighted)
        return btn
    }
    
//***********************************************关于元素的显示移动等******************************
    // 左
    @objc fileprivate func moveLeft(){
        self.delegate?.moveLeft()
    }
    
    // 自动左
    @objc fileprivate func autoMoveLeft(action: UILongPressGestureRecognizer){
        self.progressFastMove(action: action, dir: 1)
    }
    
    //右
    @objc fileprivate func moveRight(){
        self.delegate?.moveRight()
    }
    
    //自动右
    @objc fileprivate func antoMoveRight(action: UILongPressGestureRecognizer){
        self.progressFastMove(action: action, dir: 2)
    }
    
    //自动移动的处理 1左 2右
    fileprivate func progressFastMove(action: UILongPressGestureRecognizer, dir: Int){
        if action.state == UIGestureRecognizerState.ended {
            self.doingFastMove = false
        }else if action.state == UIGestureRecognizerState.began {
            self.doingFastMove = true
        }
        
        moveFastQueue.async {
            while self.doingFastMove {
                Thread.sleep(forTimeInterval: 0.1)
                mainQueue.async {
                    if self.doingFastMove {
                        if dir == 1{
                            self.delegate?.moveLeft()
                        }else{
                            self.delegate?.moveRight()
                        }
                    }
                }
            }
        }
    }
    
    //下,就是加速
    @objc fileprivate func moveDown(){
        self.originSpeed = speed
        speed = downSpeed/30
        self.delegate?.moveDownFast()  //快速响应下降按钮
    }
    
    //恢复速度
    @objc fileprivate func cancelMoveDown(){
        speed = self.originSpeed
    }
    
    //暂停 重新开始
    @objc fileprivate func pauseGame(){
        self.doingFastMove = false
        self.delegate?.pauseGame()
    }
    
    //变形
    @objc fileprivate func transformEle(){
        self.delegate?.transform()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
