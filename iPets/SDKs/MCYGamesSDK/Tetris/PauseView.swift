//
//  PauseView.swift
//  Tetris
//
//  Created by maocaiyuan on 2017/2/28.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

//pauseView的协议
protocol pauseViewDelegate {
    
    func restartGame()  //重新开始
    
    func goOnGame() //继续游戏
    
    func playMusic()  // 播放音乐
    
    func stopMusic()  //停止音乐
}

class PauseView: UIView {
    
    fileprivate var delegate : pauseViewDelegate?
    
    init(frame: CGRect, delegate: pauseViewDelegate) {
        super.init(frame: frame)
        
        self.frame = frame
        self.delegate = delegate
        
        self.setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置view
    fileprivate func setView(){
        
        self.backgroundGrammaticalization()  //背景虚化
        
        let lb = lbLook("Pausing")
        lb.center = CGPoint(x: Width/2, y: Height/2-100)
        
        let bgmlb = s_lbLook("BGM")
        bgmlb.center = CGPoint(x: 60, y: Height/2+100)
        let BGMSwitch = uiSwitch()
        BGMSwitch.center = CGPoint(x: Width-50, y: bgmlb.center.y)
        BGMSwitch.isOn = BGMAllowed
        BGMSwitch.addTarget(self, action: #selector(self.openBGM), for: .valueChanged)
        
        let restartBtn = btnLook("Restart")
        restartBtn.frame.origin = CGPoint(x: Width/2-restartBtn.frame.width-25, y: Height/2+200)
        restartBtn.addTarget(self, action: #selector(self.restartGame), for: .touchUpInside)
        
        let goOnBtn = btnLook("Continue")
        goOnBtn.frame.origin = CGPoint(x: restartBtn.frame.maxX+50, y: restartBtn.frame.minY)
        goOnBtn.addTarget(self, action: #selector(self.goOnGame), for: .touchUpInside)
        
        self.addSubview(goOnBtn)
        self.addSubview(restartBtn)
        self.addSubview(lb)
        self.addSubview(bgmlb)
        self.addSubview(BGMSwitch)
    }
    
    //背景虚化
    fileprivate func backgroundGrammaticalization(){
        //首先创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .dark)
        //接着创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        //设置模糊视图的大小（全屏）
        blurView.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
        //添加模糊视图到页面view上（模糊视图下方都会有模糊效果）
        self.addSubview(blurView)
    }
    
    //打开开关 播放音乐
    @objc fileprivate func openBGM(){
        BGMAllowed = !BGMAllowed
        
        if BGMAllowed {
            self.delegate?.playMusic()
        }else{
            self.delegate?.stopMusic()
        }
    }
    
    
    //继续游戏
    @objc fileprivate func goOnGame(){
        self.delegate?.goOnGame()
    }
    
    //重新开始
    @objc fileprivate func restartGame(){
        self.delegate?.restartGame()
    }
    
    
//==================================样式===================================
    //大lb样式
    fileprivate func lbLook(_ title: String) -> UILabel{
        let lb = UILabel()
        lb.frame.size = CGSize(width: 200, height: 50)
        lb.backgroundColor = UIColor.clear
        lb.text = title
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 40)
        return lb
    }
    
    //小lb
    fileprivate func s_lbLook(_ title: String) -> UILabel{
        let lb = UILabel()
        lb.frame.size = CGSize(width: 50, height: 20)
        lb.backgroundColor = UIColor.clear
        lb.text = title
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        lb.font = UIFont(name: "Times New Roman", size: 20)
        
        //字体名称都有哪些 我们可以通过如下方法得到
//        let arr = UIFont.familyNames
//        print(arr)
        return lb
    }
    
    //开关
    fileprivate func uiSwitch() -> UISwitch{
        let uiSwitch = UISwitch()
        return uiSwitch
    }
    
    //btn样式
    fileprivate func btnLook(_ title: String) -> UIButton{
        let btn = UIButton()
        btn.frame.size = CGSize(width: 120, height: 44)
        btn.backgroundColor = UIColor.red
        btn.layer.cornerRadius = 5
        btn.setTitle(title, for: UIControlState())
        btn.setTitleColor(UIColor.white, for: UIControlState())
        return btn
    }

}
