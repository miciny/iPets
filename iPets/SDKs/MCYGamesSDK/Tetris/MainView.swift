//
//  Main.swift
//  Tetris
//
//  Created by maocaiyuan on 2017/1/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

//mainview的协议，如到达底部了
protocol mainViewDelegate{
    
    func getTheNextOne() //到达底部，需要获取下一个元素
    
    func getLines(_ lines: Int) //消除了几行
    
    func restartRecord(over: Int) //通知游戏结束传1 重新开始记分传2
    
    func gameOver()
}

class MainView: UIView{
    
    var isGaming: TetrisGameType! //1正在游戏,2暂停，3游戏结束
    var timer: MyTimer?
    
    fileprivate var _width = CGFloat(0)
    fileprivate var _height = CGFloat(0)
    fileprivate var elements = TetrisElementsModules()
    
    fileprivate var element: TetrisElementsObj!
    
    fileprivate var wcount = Int(0) //横向格子数
    fileprivate var hcount = Int(0) //竖向格子数
    fileprivate var dir = 0 //一开始都是向上的0, 1为向右，2下，3左
    fileprivate var colorRecordArray = NSMutableArray()  //记录颜色，因为穿透的要记录下 只有点可================================
    
    fileprivate var delegate : mainViewDelegate?

    init(frame: CGRect, delegate: mainViewDelegate) {
        super.init(frame: frame)
        self.backgroundColor = BGC
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        
        self._width = frame.width
        self._height = frame.height
        self.delegate = delegate
        
        self.wcount = Int(self._width / gap)
        self.hcount = Int(self._height / gap)
        
        self.isGaming = TetrisGameType.gaming
        self.elements.centerPointNo = Int(wcount/2)  //设置显示的中心
        self.resetColorArray()
        self.setTimer()
    }

//***********************************************外部可操作******************************
    //重新开始
    func restartGame(){
        self.delegate?.restartRecord(over: 2)
        self.resetColorArray()
        self.turnAllBtnWhite()
        self.delegate?.getTheNextOne() //获取下一个元
        self.showElements()
        self.timer?.startTimer(interval: speed)
        
        speed = downSpeed //初始化速度
        self.isGaming = TetrisGameType.gaming
    }
    
    //暂停游戏 继续游戏
    func pauseGame(){
        if isGaming == TetrisGameType.gaming{
            self.timer?.pauseTimer()
            isGaming = TetrisGameType.pausing
        }else if isGaming == TetrisGameType.pausing{
            self.timer?.startTimer(interval: speed)
            isGaming = TetrisGameType.gaming
        }else if isGaming == TetrisGameType.gameOver{
            self.restartGame()
            isGaming = TetrisGameType.gaming
        }
    }
    
    //随机一个元素 从viewController传
    func getEle(_ type: Int){
        self.element = self.elements.getView(type)
    }
    
    //开始绘制页面
    func setUpView(){
        self.drawGrid() //画格子
        self.showElements()
        self.setTimer() //定时器，自动往下走的
    }
    
    //重启定时器，就是按下时，立即生效 快速响应下降按钮
    func restratTimer(){
        self.timer?.pauseTimer()
        self.timer?.startTimer(interval: speed)
    }
    
    
//***********************************************UI******************************
    //画格子
    fileprivate func drawGrid(){
        
        for j in 0 ..< wcount {
            for i in 0 ..< hcount {
                let x = gap * CGFloat(j)
                let y = gap * CGFloat(i)
                let mine = UIButton(frame: CGRect(x: x, y: y, width: gap, height: gap))
                mine.backgroundColor = BGC
                mine.layer.borderWidth = 0.5
                mine.tag = TetrisCalculate.setTag(j, j: i) //设置坐标tag
                self.addSubview(mine)
            }
        }
    }
    
    //重置颜色的数组
    fileprivate func resetColorArray(){
        self.colorRecordArray = NSMutableArray()
        self.colorRecordArray.add(BGC)
    }

//***********************************************定时器******************************
    //定时器，自动往下走
    fileprivate func setTimer(){
        self.timer = MyTimer()
        self.timer?.setTimer(interval: speed, target: self, selector: #selector(autoMoveDown), repeats: true)
    }
    
//***********************************************关于元素的显示移动等******************************
    // 显示
    fileprivate func showElements(){
        for i in self.element.elePoint {
            let x = i[0]
            let y = i[1]
            let btn = self.getBtn(x, y: y)
            self.turnBtnBlack(btn, dir: 0)
        }
    }
    
    //向下移动
    @objc fileprivate func autoMoveDown(){
        
        guard self.isGaming == TetrisGameType.gaming else {
            return
        }
        print("向下移动")
        self.timer?.pauseTimer()   //暂停计时器
        
        if !self.isDown(){
            self.notDown()
        }else{ //如果到头了
            self.alreadyDown()
        }
    }
    
    //没有到头的处理
    fileprivate func notDown(){
        self.turnElementBtnWhite(0) //先把之前变白
        for i in self.element.elePoint {
            let x = i[0]
            let y = i[1] + 1 //每个都往下移动一个
            
            let btn = self.getBtn(x, y: y)
            self.turnBtnBlack(btn, dir: 0)
            
            //删除原来的，保存新位置
            self.element.elePoint.remove(at: 0)
            self.element.elePoint.append([x, y])
        }
        self.timer?.startTimer(interval: speed)   //如果还要往下走的话，就开启
    }
    
    //到头的处理
    fileprivate func alreadyDown(){
        self.boomDownProgress()//爆炸
        
        self.isRemove() //先判断是否该消除
        self.delegate?.getTheNextOne() //获取下一个元
        self.resetColorArray()  //重置颜色的array
        
        if isGameOver(){ //再判断游戏结束
            TetrisCalculate.systemVibration() //震动
            self.showElements() //显示下一个元素
            self.gameOverAlert()
            isGaming = TetrisGameType.gameOver
            speed = downSpeed //速度可能出问题，这里初始化一下
            self.delegate?.restartRecord(over: 1)
            print("游戏结束")
        }else{ //游戏没结束
            dir = 0
            self.showElements() //显示下一个元素
            self.timer?.startTimer(interval: speed)
        }
    }
    
    //结束后的弹窗
    func gameOverAlert(){
        self.delegate?.gameOver()
    }

    
    
    // 炸弹到头的处理,中心方圆5里爆炸
    fileprivate func boomDownProgress(){
        guard self.element.eleFunction == TetrisEleFunction.boom else {
            return
        }
        let range = 4
        let point = self.element.elePoint[self.element.ceterPonintNo]
        
        let up = point[1]-range < 0 ? 0 : point[1]-range
        let down = point[1]+range >= hcount ? hcount-1 : point[1]+range
        let left = point[0]-range < 0 ? 0 : point[0]-range
        let right = point[0]+range >= wcount ? wcount-1 : point[0]+range
        
        for j in up ..< down+1{
            for i in left ..< right+1{
                let btn = getBtn(i, y: j)
                btn.backgroundColor = BGC
            }
        }
    }
    
    //左右移动,-1左，1为右
    func moveLeftOrRight(_ dir: Int){
        if dir == -1{
            guard !isLeft() && isGaming == TetrisGameType.gaming else{
                return
            }
        }else{
            guard !isRight() && isGaming == TetrisGameType.gaming else{
                return
            }
        }
        self.turnElementBtnWhite(dir) //先把之前变白
        
        for i in self.element.elePoint {
            let x = i[0] + dir //每个都往右移动一个
            let y = i[1]
            let btn = self.getBtn(x, y: y)
            self.turnBtnBlack(btn, dir: dir) //显示移动过后的
            
            self.element.elePoint.remove(at: 0)
            self.element.elePoint.append([x, y])
        }
    }
    
    //变形
    func transformEle(){
        guard isGaming == TetrisGameType.gaming else{
            return
        }
        
        var newElement = [[Int]]()
        newElement = self.elements.getTurnedView(self.element.elePoint, dir: dir, wcount: wcount)
        
        //如果没占领，就变
        if self.isAlreadyShow(newElement) {
            self.turnElementBtnWhite(0) //清除原先的
            self.element.elePoint = newElement
            self.showElements() //立马显示
            dir = dir==3 ? 0 : dir+1 //转一个圈
        }
    }
    
    
//***********************************************游戏的判断******************************
    
    //变形后，新位置如果已经被占领了或者超出上下面的界限了就返回false,不检查新位置与旧位置重叠的部分
    fileprivate func isAlreadyShow(_ newEle: [[Int]]) -> Bool{
        var isAlready = true
        let eleArray = NSMutableArray()
        eleArray.addObjects(from: self.element.elePoint)
        
        for ne in newEle {
            if !eleArray.contains(ne) {
                let x = ne[0]
                let y = ne[1]
                if y >= hcount || y < 0{
                    isAlready = false
                    break
                }else{
                    let btn = self.getBtn(x, y: y)
                    if btn.backgroundColor != BGC{
                        isAlready = false
                        break
                    }
                }
            }
        }
        return isAlready
    }
    
    //判断是否消除,检测 刚下来的几行
    fileprivate func isRemove(){
        var linesArray = [Int]() //消除哪几行
        var yArray = [Int]() //记录要检测的哪几行
        for i in self.element.elePoint {
            let y = i[1]
            if !yArray.contains(y){ //去重
                yArray.append(y)
            }
        }
        
        for y in yArray {
            var shouldRemoveFlag = true //是否这一行该消除
            for j in 0 ..< wcount{
                let x = j
                let btn = self.getBtn(x, y: y)
                if btn.backgroundColor == BGC {
                    shouldRemoveFlag = false
                    break
                }
            }
            
            //如果该消除了，就添加到消除数组里
            if shouldRemoveFlag == true {
                linesArray.append(y)
            }
        }
    
        //如果消除了，就传值
        let lines = linesArray.count
        if lines > 0 {
            self.downmoveElementBtn(linesArray) //消除
            self.delegate?.getLines(lines)
        }
    }
    
    //判断左方到头了没
    fileprivate func isLeft() -> Bool{
        let checkPoint = self.elements.checkPoint(self.element.elePoint, checkDir: 1)
        
        var isLeft = false
        for point in checkPoint{
            let x = point[0]-1 //左边那个
            let y = point[1]
            
            if x < 0{
                isLeft = true
                break
            }else{
                isLeft = self.isBlack(x, y: y)
                if isLeft == true {
                    break
                }
            }
        }
        return isLeft
    }
    
    //判断右方到头了没
    fileprivate func isRight() -> Bool{
        let checkPoint = self.elements.checkPoint(self.element.elePoint, checkDir: 2)
        
        var isRight = false
        for point in checkPoint{
            let x = point[0]+1
            let y = point[1]
            
            if x >= wcount{
                isRight = true
                break
            }else{
                isRight = self.isBlack(x, y: y)
                if isRight == true {
                    break
                }
            }
        }
        return isRight
    }
    
    //判断下方到头没,到头了true 。 根据dir和ele类型，选择需要判断的点
    fileprivate func isDown() -> Bool{
        let checkPoint = self.elements.checkPoint(self.element.elePoint, checkDir: 0)
        
        var isDown = false
        
        //最大的空白地方的y 可穿透的,只有点可以=====================================================================
        if self.element.eleFunction == TetrisEleFunction.invisible{
            return self.eleInvisibleProgress()
        }
        
        //普通的
        for point in checkPoint{
            let x = point[0]
            let y = point[1]+1
            
            if y >= hcount{
                isDown = true
                break
            }else{
                isDown = self.isBlack(x, y: y)
                if isDown == true {
                    break
                }
            }
        }
        return isDown
    }
    
    //元素是可穿透的，下降时的处理 可穿透的,只有点可以=====================================================================
    fileprivate func eleInvisibleProgress() -> Bool{
        var maxy = 0  //保存最大的空白地方的y
        for e in self.element.elePoint {
            let x = e[0] //获取x坐标
            for y in 0 ..< hcount{
                let btn = self.getBtn(x, y: y)
                if btn.backgroundColor == BGC{
                    maxy = y
                }
            }
        }
        
        let e = element.elePoint[0]
        if e[1] < maxy {
            return false
        }else{
            return true
        }
    }
    
    //根据x y ，是黑色的就返回true
    fileprivate func isBlack(_ x: Int, y: Int) -> Bool{
        let btn = self.getBtn(x, y: y)
        if btn.backgroundColor != BGC {
            return true
        }else{
            return false
        }
    }
    
    //判断游戏结束
    fileprivate func isGameOver() -> Bool{
        var gameover = false
        for e in self.element.elePoint{
            let y = e[1] //
            let x = e[0]
            if self.isBlack(x, y: y){
                gameover = true
                break
            }
        }
        return gameover
    }
    
    
//***********************************************Btn的操作******************************
    
    //btn变颜色 只有点可以变红=====================================================================
    fileprivate func turnBtnBlack(_ btn: UIButton, dir: Int){
        if self.element.eleFunction == TetrisEleFunction.invisible && colorRecordArray.lastObject as? UIColor != BGC && dir==0{
            btn.backgroundColor = UIColor.red
        }else{
            btn.backgroundColor = self.element.color
        }
    }
    
    //元素的btn变白 -1左 1为右 0为下
    fileprivate func turnElementBtnWhite(_ dir: Int){
        
        //穿透 记录之前的颜色，本身和下一个，只有点可以=====================================================================
        if self.element.eleFunction == TetrisEleFunction.invisible{
            for i in self.element.elePoint{
                let x = i[0]+dir
                let y = i[1]+1
                let btn = self.getBtn(x, y: y)
                if let color = btn.backgroundColor{
                    colorRecordArray.add(color)
                }
            }
            
            //只记录两个
            if colorRecordArray.count == 3 {
                colorRecordArray.removeObject(at: 0)
            }
        }
        
        //移动时，把自身位置的颜色弄成数组的第一个颜色
        for i in self.element.elePoint{
            let x = i[0]
            let y = i[1]
            let btn = self.getBtn(x, y: y)
            if self.element.eleFunction == TetrisEleFunction.invisible{ //只有点可以============================================
                btn.backgroundColor = colorRecordArray.firstObject as? UIColor
            }else{
                btn.backgroundColor = BGC
            }
        }
        
        //如果最有移动，要把颜色数组的第二个改为白色
        if dir != 0{
            colorRecordArray.removeLastObject()
            colorRecordArray.add(BGC)
        }
    }
    
    //元素的btn一行变白,Line行号 y
    fileprivate func turnOneLineElementBtnWhite(_ line: Int){
        let y = line
        for i in 0 ..< wcount {
            let x = i
            let btn = self.getBtn(x, y: y)
            btn.backgroundColor = BGC
        }
    }
    
    //元素的btn整体下降,Line行号[Int] y，y之上的都下降，因为消除了
    fileprivate func downmoveElementBtn(_ lines: [Int]){
        let linesT = lines.sorted(by: tetrisGetSort)
        
        for line in linesT{
            let yy = line
            self.turnOneLineElementBtnWhite(yy)
            for x in 0 ..< wcount {
                for j in 0 ..< yy {
                    let y = yy - j - 1
                    let btn = self.getBtn(x, y: y)
                    if btn.backgroundColor != BGC {  //自己是黑色的，下方的格子就变黑
                        let ybtn = self.getBtn(x, y: y+1) //下方的格子
                        ybtn.backgroundColor = btn.backgroundColor
                        btn.backgroundColor = BGC //之前那个变白
                    }
                }
            }
        }
    }
    
    //所有的btn变白
    fileprivate func turnAllBtnWhite(){
        for sub in self.subviews{
            sub.backgroundColor = BGC
        }
    }
    
    //根据坐标，返回btn
    fileprivate func getBtn(_ x: Int, y: Int) -> UIButton{
        let tag = TetrisCalculate.setTag(x, j: y)
        var btn = UIButton()
        for sub in self.subviews{
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
