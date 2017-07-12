//
//  TipsView.swift
//  Tetris
//
//  Created by maocaiyuan on 2017/1/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class TipsView: UIView {
    
    fileprivate var nextView = UIView()
    fileprivate var elements2 = TetrisElementsModules()
    fileprivate var element2: TetrisElementsObj!
    fileprivate var elementTemp: TetrisElementsObj!  //临时保存第一个，因为要下降
    
    fileprivate var elements1 = TetrisElementsModules()
    fileprivate var element1: TetrisElementsObj!
    
    var timer: MyTimer?
    fileprivate var wcount = Int(5) //横向格子数
    fileprivate var hcount = Int(15) //纵向格子数
    fileprivate var scoreLb: UILabel! //显示分数
    fileprivate var levelLb: UILabel! //显示等级
    fileprivate var score = 0 //分数
    fileprivate var level = 0 //等级
    fileprivate var getEleFlag = false // 获取元素的次数，是开启下降动画的标志
    fileprivate var moveSpeed = TimeInterval(0.03)
    
    fileprivate var isMoving = false //获取下一个元素时，还在下降的标志

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = BGC
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        
        self.elements2.centerPointNo = Int(wcount/2)  //设置显示的中心
        self.elements1.centerPointNo = Int(wcount/2)  //设置显示的中心
        self.setUpView()
        self.setTimer()
    }
    
//==========ui===================================================
    //设置界面
    fileprivate func setUpView(){
        //显示下两个个元素
        self.nextView = self.setupNextView()
        self.nextView.center.x = self.frame.width/2
        self.nextView.frame.origin.y = 20
        self.nextView.layer.masksToBounds = true
        self.addSubview(self.nextView)
        
        //下面的等级 分数
        let scoreView = UIView(frame: CGRect(x: 0, y: self.nextView.frame.maxY,
                                             width: self.frame.width, height: self.frame.height-self.nextView.frame.maxY))
        
        //分数
        let titleLb = lbLook("Top Score", textColor: UIColor.white, font: 17)
        titleLb.frame = CGRect(x: 0, y: 80, width: self.frame.width, height: 20)
        self.scoreLb = lbLook("0", textColor: UIColor.red, font: 20)
        self.scoreLb.frame = CGRect(x: 0, y: titleLb.frame.maxY+5, width: self.frame.width, height: 20)
        
        //等级
        self.levelLb = lbLook("1", textColor: UIColor.red, font: 20)
        self.levelLb.frame = CGRect(x: 0, y: scoreView.frame.height-40, width: self.frame.width, height: 20)
        let titleLb1 = lbLook("Level", textColor: UIColor.white, font: 17)
        titleLb1.frame = CGRect(x: 0, y: self.levelLb.frame.minY-self.levelLb.frame.height-5, width: self.frame.width, height: 20)
        
        scoreView.addSubview(self.scoreLb)
        scoreView.addSubview(titleLb)
        scoreView.addSubview(self.levelLb)
        scoreView.addSubview(titleLb1)
        self.addSubview(scoreView)
    }
    
    //显示下一个元素view
    fileprivate func setupNextView() -> UIView{
        let view = UIView()
        view.frame.size = CGSize(width: gap * CGFloat(wcount), height: gap * CGFloat(hcount-wcount))
        
        for i in 0 ..< hcount {
            for j in 0 ..< wcount {
                let x = gap * CGFloat(j)
                let y = gap * CGFloat(i - 5)
                let mine = UIButton(frame: CGRect(x: x, y: y, width: gap, height: gap))
                mine.backgroundColor = BGC
                mine.layer.borderWidth = 0.5
                mine.layer.masksToBounds = true
                mine.tag = TetrisCalculate.setTag(j, j: i) //设置坐标tag
                view.addSubview(mine)
            }
        }
        return view
    }
    
    //lb样式
    fileprivate func lbLook(_ title: String, textColor: UIColor, font: CGFloat) -> UILabel{
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: font)
        lb.text = title
        lb.textColor = textColor
        return lb
    }
    
//========== 分数等级===================================================
    //更新分数
    func updateScore(_ lines: Int){
        score = score + Int(pow(2.0, Double(lines))) * 10  //2的n次方 分数
        self.scoreLb.text = String(score)
        
        level = Int(score)/300 + 1
        self.levelLb.text = String(level)
        
        speed = downSpeed - TimeInterval(0.1 * Double(level-1))
    }
    
//==========操作===================================================
    //随机一个元素 从viewController传
    func getEle(_ type: Int, type2: Int){
        log.info("显示下两个元素")
        
        if let temp = self.element1{
            if self.isMoving == true{  //如果获取新元素时，还在动，temp消除，重新显示ele1 ele2
                self.elementTemp = nil
            }else{
                self.elementTemp = temp
            }
        }
        
        self.element2 = self.elements2.getView(type2)     //接下来的第二个
        self.element1 = self.elements1.getView(type)    //接下来的第一个
        
        if isMoving == true{
            self.timer?.pauseTimer()
            self.isMoving = false
            self.ele1Plus(dlt: 5)  //+5处理 //重新显示ele1 ele2 1+10 2+5
            self.ele2Plus(dlt: 5)  //+5处理
        }
        
        if getEleFlag == true{
            self.turnElementBtnWhite() //先把之前变白
            self.ele1Plus(dlt: 5)  //+5处理
            self.showNextEle()
            self.timer?.startTimer(interval: moveSpeed)
        }
        
        //第一次进来，显示的位置
        if getEleFlag == false{
            getEleFlag = true
            self.ele1Plus(dlt: 10)  //+10处理
            self.ele2Plus(dlt: 5)  //+5处理
            self.showNextEle()
        }
    }
    
    //显示下一个元素
    func showNextEle(){
        for i in self.element2.elePoint {
            let x = i[0]
            let y = i[1]
            let btn = self.getBtn(x, y: y)
            self.turnBtnBlack(btn, eleNo: 2)
        }
        
        for i in self.element1.elePoint {
            let x = i[0]
            let y = i[1]
            let btn = self.getBtn(x, y: y)
            self.turnBtnBlack(btn, eleNo: 1)
        }
        
        if let temp = self.elementTemp{
            for i in temp.elePoint {
                let x = i[0]
                let y = i[1]
                let btn = self.getBtn(x, y: y)
                self.turnBtnBlack(btn, eleNo: 0)
            }
        }
    }
    
    //重新开始游戏 1只是结束，2结束加重新计分
    func restartRecord(over: Int){
        log.info("重置分数和元素")
        
        self.timer?.pauseTimer()
        self.elementTemp = nil
        self.getEleFlag = false
        self.isMoving = false
        
        if over == 2{
            self.turnElementBtnWhite()
            score = 0
            self.scoreLb.text = String(score)
            level = 1
            self.levelLb.text = String(level)
            self.element1 = nil
        }else{
            self.turnElementBtnWhite()
            
            // 有时出现左边错误，具体原因估计与自动下移有关
            if element1.elePoint[0][1] < 10 {
                self.ele1Plus(dlt: 5)  //+10处理
                self.ele2Plus(dlt: 5)  //+5处理
            }
            self.showNextEle()
            self.element1 = nil
        }
    }
    
    //第一个元素显示时,y的位移
    fileprivate func ele1Plus(dlt: Int){
        for i in 0 ..< self.element1.elePoint.count{
            let e = self.element1.elePoint[i]
            let x = e[0]
            let y = e[1]+dlt
            
            self.element1.elePoint[i] = [x, y]
        }
    }
    
    //第二个元素显示时,y的位移
    fileprivate func ele2Plus(dlt: Int){
        for i in 0 ..< self.element2.elePoint.count{
            let e = self.element2.elePoint[i]
            let x = e[0]
            let y = e[1]+dlt
            
            self.element2.elePoint[i] = [x, y]
        }
    }
    
    //自动下降
    @objc fileprivate func autoMoveDown(){
        self.timer?.pauseTimer()   //暂停计时器
        
        guard self.elementTemp != nil else {
            return
        }
        
        if !self.isDown(){
            self.isMoving = true
            self.notDown()
        }else{ //如果到头了
            self.isMoving = false
            self.timer?.pauseTimer()
        }
    }
    
    //如果没有消失，自动往下移
    fileprivate func notDown(){
        self.turnElementBtnWhite() //先把之前变白
        
        for i in self.elementTemp.elePoint {
            let x = i[0]
            let y = i[1] + 1 //每个都往下移动一个
            
            let btn = self.getBtn(x, y: y)
            self.turnBtnBlack(btn, eleNo: 0)
            
            //删除原来的，保存新位置
            self.elementTemp.elePoint.remove(at: 0)
            self.elementTemp.elePoint.append([x, y])
        }
        
        for i in self.element1.elePoint {
            let x = i[0]
            let y = i[1] + 1 //每个都往下移动一个
            
            let btn = self.getBtn(x, y: y)
            self.turnBtnBlack(btn, eleNo: 1)
            
            //删除原来的，保存新位置
            self.element1.elePoint.remove(at: 0)
            self.element1.elePoint.append([x, y])
        }
        
        for i in self.element2.elePoint {
            let x = i[0]
            let y = i[1] + 1 //每个都往下移动一个
            
            let btn = self.getBtn(x, y: y)
            self.turnBtnBlack(btn, eleNo: 2)
            
            //删除原来的，保存新位置
            self.element2.elePoint.remove(at: 0)
            self.element2.elePoint.append([x, y])
        }
        
        self.timer?.startTimer(interval: moveSpeed)   //如果还要往下走的话，就开启
    }
    
    //显示下一个后，之前的那个自动往下移，直至移出屏幕的判断
    fileprivate func isDown() -> Bool{
        
        var flag = true
        for e in self.elementTemp.elePoint{
            let y = e[1]
            if y < hcount{
                flag = false
                break
            }
        }
        return flag
    }
    
//***********************************************定时器******************************
    //定时器，自动往下走
    fileprivate func setTimer(){
        self.timer = MyTimer()
        self.timer?.setTimer(interval: moveSpeed, target: self, selector: #selector(autoMoveDown), repeats: true)
        self.timer?.pauseTimer()
    }
    
    
//***********************************************Btn的操作******************************
    //btn变颜色
    fileprivate func turnBtnBlack(_ btn: UIButton, eleNo: Int){
        if eleNo == 2{
            btn.backgroundColor = self.element2.color
        }else if eleNo == 1{
            btn.backgroundColor = self.element1.color
        }else{
            btn.backgroundColor = self.elementTemp.color
        }
    }
    
    //元素的btn变白
    fileprivate func turnElementBtnWhite(){
        
        for sub in self.nextView.subviews{
            let btn = sub as! UIButton
            btn.backgroundColor = BGC
        }
        
    }
    
    //根据坐标，返回btn
    fileprivate func getBtn(_ x: Int, y: Int) -> UIButton{
        let tag = TetrisCalculate.setTag(x, j: y)
        var btn = UIButton()
        
        for sub in self.nextView.subviews{
            if sub.tag == tag{
                btn = sub as! UIButton
                break
            }
        }
        return btn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
