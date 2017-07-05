//
//  ViewController.swift
//  Tetris
//
//  Created by maocaiyuan on 2017/1/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit
import AVFoundation

class TetrisGameViewController: UIViewController, controllerViewDelegate, mainViewDelegate, pauseViewDelegate{
    var mainView: MainView?
    var tipsView: TipsView?
    var controllerViw: ControllerView?
    var pauseView: PauseView?
    var player: AudioPlayer?    //不要把 AVAudioPlayer 当做局部变量 可能要用 AVAudioSession，否则木有声音啊
    
    var typeArray = [Int]() //保存现在显示的和下一个

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BGC
        
        self.setUpView()
        
        self.getEle() //一进来传一个元素
        self.mainView?.setUpView() //开始动
        self.tipsView?.showNextEle() //显示当前一个
        
        self.playBGM()
    }
    
    //退出界面，菜单消失
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("game over manul")
        
        mainView?.isGaming = TetrisGameType.pausing
        mainView?.timer?.stopTimer()
        tipsView?.timer?.stopTimer()
        mainView?.timer = nil
        tipsView?.timer = nil
        mainView?.removeFromSuperview()
        tipsView?.removeFromSuperview()
        controllerViw?.removeFromSuperview()
        pauseView?.removeFromSuperview()
        
        self.stopMusic()
        
        mainView = nil
        tipsView = nil
        controllerViw = nil
        pauseView = nil
        player = nil
    }

    
    // 播放音乐
    func playBGM(){
        self.player = AudioPlayer.shared
        self.player!.setUp(path: Bundle.main.path(forResource: "A_comme_amour", ofType: "mp3")!, autoPlay: true)
        if BGMAllowed {
            self.player?.playAudio()
        }
    }

    
//==== ui ===========================================================================
    
    //设置三个区域
    func setUpView(){
        self.title = "Tetris"
        let mainViewWidth = CGFloat(Int((Width*0.65)/gap))*gap   //必须为gap的整数倍，不然显示不好
        let mainViewHeight = CGFloat(Int(Width/gap))*gap
        
        self.mainView = MainView(frame: CGRect(x: 10, y: 64,
            width: mainViewWidth, height: mainViewHeight), delegate: self)
        self.tipsView = TipsView(frame: CGRect(x: (self.mainView?.frame.maxX)!+5, y: 64,
            width: Width-25-mainViewWidth, height: (self.mainView?.frame.height)!))
        self.controllerViw = ControllerView(frame: CGRect(x: 0, y: (self.mainView?.frame.maxY)!+10,
            width: Width, height: Height - Width - 90), delegate: self)
        
        self.view.addSubview(self.mainView!)
        self.view.addSubview(self.tipsView!)
        self.view.addSubview(self.controllerViw!)
        
        //左上角联系人按钮按钮，一下方法添加图片，需要对图片进行遮罩处理，否则不会出现图片
        // 我们会发现出来的是一个纯色的图片，是因为iOS扁平化设计风格应用之后做成这样的，如果需要现实图片，我们可以设置一项
        var image = UIImage(named:"MoreSetting")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let contectItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(setGamePause))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)  //用于消除左边空隙，要不然按钮顶不到最前面
        spacer.width = -5
        self.navigationItem.rightBarButtonItems = [spacer, contectItem]
    }
    
    //设置暂停的弹层
    func setGamePause(){
        self.mainView?.pauseGame()
        if pauseView == nil{
            pauseView = PauseView(frame: self.view.frame, delegate: self)
            self.view.addSubview(pauseView!)
        }else{
            pauseView?.removeFromSuperview()
            pauseView = nil
        }
    }
    
    //消失弹层
    func disappearPauseView(){
        if pauseView != nil{
            pauseView?.removeFromSuperview()
            pauseView = nil
        }
    }
    
    /**
     设置状态栏风格,系统栏白色文字 info中 View controller-based status bar appearance设置为no才能用
     **/
    func MyPreferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
//==========规则==================================
    
    //随机两个 一个显示 一个是下一次显示的
    func getEle(){
        self.setEleRange()
        print(typeArray)
        print("获取下一个元素")
        self.mainView?.getEle(typeArray[0])
        
        //显示第二个时，-1则显示第三个，不会出现两个-1连着的情况
        var eleNo2 = typeArray[2]
        if eleNo2 == -1{
            eleNo2 = typeArray[3]
        }
        
        self.tipsView?.getEle(typeArray[1], type2: eleNo2)
    }
    
    // 元素出现的先后顺序规则
    // 21+22 <= 5
    // 15+4 + 16 <= 5 = 3  不要随机16了
    // 9+18 <= 4  先9，不要随机18了
    //
    func setEleRange(){
        if typeArray.count == 0{
            for _ in 0 ..< 12{
                typeArray.append(TetrisCalculate.getRandomNo(minE, max: maxE))
            }
//            typeArray = [22, 15, 4, 9, 21, 22, 3, 6, 11, 12, 13]
        }else{
            typeArray.remove(at: 0)
            typeArray.append(TetrisCalculate.getRandomNo(minE, max: maxE))
        }
        
        //-1的标志，去掉死循环的
        guard typeArray[1] != -1 else {
            self.dropCircle()
            return
        }
        
        let no = typeArray[0]
        if no == 9 {                        // 9+18 <= 4  先9，不要随机18了
            self.progress9()
        }else if no == 21 || no == 22{      // 21+22 <= 5
            self.progress21_22(no: no)
        }else if no == 15 || no == 4{       // 15+4 + 16 <= 5 = 3  不要随机16了
            self.progress15_4_17(no: no)
        }
    }

    func progress9(){
        var rangeDlt = TetrisCalculate.randomNo(1, max: 5)
        if typeArray[rangeDlt+1] == -1{
            rangeDlt += 1
        }
        typeArray.removeLast()
        typeArray.insert(18, at: rangeDlt)
    }
    
    func progress21_22(no: Int){
        //接下来5个内得没有21 或者 22
        let need = no == 21 ? 22 : 21
        var have = false
        
        for i in 1 ..< 6{
            let nextNo = typeArray[i]
            
            if need == nextNo && have == false{
                have = true
                self.avoidCircle(index: i)
            }else if nextNo == no || need == nextNo{
                //有重复的，重新随机添加，新添加的也不能重复
                var a = nextNo
                while a == need || a == no{
                    a = TetrisCalculate.getRandomNo(minE, max: maxE)
                }
                typeArray[i] = a
            }
            
        }
        
        //没有的话就自动添加一个21 或者 22
        if !have{
            var rangeDlt = TetrisCalculate.randomNo(1, max: 6)
            if typeArray[rangeDlt+1] == -1{
                rangeDlt += 1
            }
            
            typeArray.removeLast()
            typeArray.insert(need, at: rangeDlt)
            self.avoidCircle(index: rangeDlt)
        }
    }
    
    func progress15_4_17(no: Int){
        //接下来5个内得没有15 或者 4
        let need = no == 15 ? 4 : 15
        var have = false
        var index = 0  //如果有，则记录位置
        
        for i in 1 ..< 6{
            let nextNo = typeArray[i]
            
            if need == nextNo && have == false{
                have = true
                index = i
                self.avoidCircle(index: i)
            }else if nextNo == no || need == nextNo{
                //有重复的，重新随机添加，新添加的也不能是重复
                var a = nextNo
                while a == need || a == no{
                    a = TetrisCalculate.getRandomNo(minE, max: maxE)
                }
                typeArray[i] = a
            }
        }
        
        //没有的话就自动添加一个15 或者 4
        if !have{
            let rangeDlt = TetrisCalculate.randomNo(1, max: 6)
            var dlt = 0
            if typeArray[rangeDlt+1] == -1{
                dlt = 1
            }
            typeArray.insert(need, at: rangeDlt+dlt)
            
            if typeArray[rangeDlt+dlt+3] == -1{
                dlt += 1
            }
            typeArray.insert(16, at: rangeDlt+3+dlt)
            typeArray.removeLast()
            typeArray.removeLast()
            self.avoidCircle(index: rangeDlt)
        }else{
            var dlt = 0
            if typeArray[index+3] == -1{
                dlt = 1
            }
            typeArray.insert(16, at: index+3+dlt)
            typeArray.removeLast()
        }
    }
    
    //需添加-1的标志，不然会进入死循环
    func avoidCircle(index: Int){
        typeArray.insert(-1, at: index+1)  // 避免进入死循环
        typeArray.removeLast()
    }
    
    //去掉-1的标示
    func dropCircle(){
        typeArray.remove(at: 1)
        typeArray.append(TetrisCalculate.getRandomNo(minE, max: maxE))
    }
    
//=======================协议===========================
    
    //controllerViewDelegate=============================
    //左
    func moveLeft() {
        self.mainView?.moveLeftOrRight(-1)
    }
    
    //右
    func moveRight() {
        self.mainView?.moveLeftOrRight(1)
    }
    
    //暂停
    func pauseGame() {
        self.mainView?.pauseGame()
    }
    
    //变形
    func transform() {
        self.mainView?.transformEle()
    }
    
    
    //mainViewDelegate=============================
    //获取下一个元素
    func getTheNextOne() {
        //判断相当于重新开始
        if self.mainView?.isGaming == TetrisGameType.gameOver{
            self.typeArray = [Int]() //初始化
        }
        self.getEle()
    }
    
    //消除了几行
    func getLines(_ lines: Int) {
        self.tipsView?.updateScore(lines)
    }
    
    //重新开始记分
    func restartRecord(over: Int) {
        self.tipsView?.restartRecord(over: over)
    }
    
    func gameOver(){
        let alertView = UIAlertController(title: "Game Over", message: "骚年仍需努力！\n相信下次你会拥有更低的分数", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertView.addAction(okAction)// 当添加的UIAlertAction超过两个的时候，会自动变成纵向分布
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    //pauseViewDelegate==========================
    //继续游戏
    func goOnGame() {
        self.disappearPauseView()
        self.mainView?.pauseGame()
    }
    
    //重新开始游戏
    func restartGame() {
        self.disappearPauseView()
        self.typeArray = [Int]() //初始化
        self.tipsView?.restartRecord(over: 2)
        self.getEle()
        self.mainView?.restartGame()
    }
    
    func stopMusic() {
        self.player?.stopAudio()
    }
    
    func playMusic() {
        self.player?.playAudio()
    }
    
    //重启定时器，快速响应下降按钮
    func moveDownFast() {
        self.mainView?.restratTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

