//
//  ViewController.swift
//  MineClearance
//
//  Created by maocaiyuan on 2017/1/19.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class MineMainViewController: UIViewController{
    
    var mineView: MineView?
    var viewCount: Int! //雷区每行每列的数量
    var mineCount: Int! //雷的数量
    var positionArray: NSMutableArray!  //雷的位置的数组
    var markBtn: UIBarButtonItem?  //标记按钮
    
    var resetBtn: UIButton!  //重制按钮
    var simpleBtn: UIButton!
    var superiorBtn: UIButton!
    var diffcultBtn: UIButton!
    
    var mainScroll: UIScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewAndData()    //设置标题
        
        self.setMinePosition()  //设置雷的位置
        
        self.setScroll()
        self.setMineView()  //雷区
        self.setSettingView()
    }
    
    //设置标题数据等
    func initViewAndData(){
        self.title = "扫雷"
        self.view.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        
        self.markBtn = UIBarButtonItem(title: "标记", style: .plain, target: self, action:
            #selector(markMine))
        self.navigationItem.rightBarButtonItem = self.markBtn
        
        self.viewCount = rows
        self.mineCount = mines
    }
    
    //重制
    @objc func resetAll(){
        self.setMinePosition()  //设置雷的位置
        self.mineView?.removeFromSuperview()
        self.mineView = nil
        self.setMineView()  //雷区
        self.markBtn?.title = "标记"
        
    }
    
    //标记
    @objc func markMine(){
        if self.mineView?.markFlag == false{
            self.markBtn?.title = "取消标记"
            self.mineView?.markFlag = true
        }else{
            self.markBtn?.title = "标记"
            self.mineView?.markFlag = false
        }
    }

//********************************************************UI类************************************************
    //滚动
    func setScroll(){
        self.mainScroll = UIScrollView(frame: CGRect(x: 0, y: 10, width: Width, height: Height))
        self.mainScroll!.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        self.mainScroll!.showsVerticalScrollIndicator = true
        self.mainScroll!.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.mainScroll!)
    }
    
    //雷区
    func setMineView() {
        self.mineView = MineView(frame: CGRect.zero, count: self.viewCount, minePosition: self.positionArray)
        self.mineView!.delegate = self
        self.self.mainScroll!.addSubview(self.mineView!)
    }
    
    //设置项
    func setSettingView(){
        
        simpleBtn = myBtn("简单")
        superiorBtn = myBtn("中级")
        diffcultBtn = myBtn("高级")
        
        simpleBtn.frame.origin = CGPoint(x: 25, y: self.mineView!.maxYY+20)
        superiorBtn.frame.origin = CGPoint(x: simpleBtn.maxXX+10, y: self.mineView!.maxYY+20)
        diffcultBtn.frame.origin = CGPoint(x: superiorBtn.maxXX+10, y: self.mineView!.maxYY+20)
        simpleBtn.backgroundColor = UIColor.red
        
        
        resetBtn = myBtn("重新开始")
        resetBtn.frame = CGRect(x: 20, y: simpleBtn.maxYY+30, width: Width-40, height: 44)
        resetBtn.addTarget(self, action: #selector(resetAll), for: .touchUpInside)
        
        
        self.mainScroll!.addSubview(simpleBtn)
        self.mainScroll!.addSubview(superiorBtn)
        self.mainScroll!.addSubview(diffcultBtn)
        self.mainScroll!.addSubview(resetBtn)
        
        simpleBtn.addTarget(self, action: #selector(simpleRestart), for: .touchUpInside)
        superiorBtn.addTarget(self, action: #selector(superiorRestart), for: .touchUpInside)
        diffcultBtn.addTarget(self, action: #selector(diffcultRestart), for: .touchUpInside)
    }
    
    //按钮点击事件
    @objc func simpleRestart(){
        self.viewCount = 10
        self.mineCount = 30
        simpleBtn.backgroundColor = UIColor.red
        superiorBtn.backgroundColor = UIColor.lightGray
        diffcultBtn.backgroundColor = UIColor.lightGray
        self.resetAll()
    }
    
    //按钮点击事件
    @objc func superiorRestart(){
        self.viewCount = 19
        self.mineCount = 88
        simpleBtn.backgroundColor = UIColor.lightGray
        superiorBtn.backgroundColor = UIColor.red
        diffcultBtn.backgroundColor = UIColor.lightGray
        self.resetAll()
    }
    
    //按钮点击事件
    @objc func diffcultRestart(){
        self.viewCount = 30
        self.mineCount = 155
        simpleBtn.backgroundColor = UIColor.lightGray
        superiorBtn.backgroundColor = UIColor.lightGray
        diffcultBtn.backgroundColor = UIColor.red
        self.resetAll()
    }
    
    
    //label样式
    func myBtn(_ str: String) -> UIButton{
        let btn = UIButton()
        btn.setTitle(str, for: .normal)
        btn.frame.size = CGSize(width: 100, height: 44)
        btn.layer.cornerRadius = 8
        
        btn.backgroundColor = UIColor.lightGray
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }

//********************************************************计算类************************************************
    
    //雷的位置
    func setMinePosition(){
        self.positionArray = NSMutableArray()
        while self.positionArray.count < self.mineCount{
            let position = MineCalculate.minePosition(self.viewCount)
            if !positionArray.contains(position){         //去重
                positionArray.add(position)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MineMainViewController: MineViewDelegate{
    
    func GameOver() {
        let alertView = UIAlertController(title: "Game Over", message: "骚年仍需努力！\n相信下次你会拥有更低的分数", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertView.addAction(okAction)// 当添加的UIAlertAction超过两个的时候，会自动变成纵向分布
        self.present(alertView, animated: true, completion: nil)
    }
    
    func GameVictory() {
        
        let alertView = UIAlertController(title: "Congratulations！", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertView.addAction(okAction)// 当添加的UIAlertAction超过两个的时候，会自动变成纵向分布
        self.present(alertView, animated: true, completion: nil)
    }
}


