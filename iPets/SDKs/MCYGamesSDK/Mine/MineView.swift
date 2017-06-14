//
//  MineView.swift
//  MineClearance
//
//  Created by maocaiyuan on 2017/1/19.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

protocol MineViewDelegate {
    
    func GameOver()
    
    func GameVictory()
}


class MineView: UIView {

    fileprivate var count: Int? //雷区每行的数量
    fileprivate var minePosition: NSMutableArray? //雷的位置
    fileprivate var markedMinePosition: NSMutableArray? //标记的雷的位置
    fileprivate var allMineView: UIView?   //显示雷的区域
    fileprivate var mineLabel: UILabel?
    
    var delegate: MineViewDelegate?
    
    var markFlag: Bool! //标记状态，true时，点击为标记作用，false时点击为普通模式
    
    var checkedPoint: NSMutableArray? //已检测的位置
    
    init(frame: CGRect, count: Int, minePosition: NSMutableArray) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 10, y: 0, width: Width-20, height: Width+20)
        self.allMineView = UIView(frame: CGRect(x: 0, y: 0, width: Width-20, height: Width-20))
        self.addSubview(self.allMineView!)
        self.allMineView!.backgroundColor = UIColor.darkGray
        self.backgroundColor = UIColor.white
        
        self.count = count
        self.minePosition = minePosition
        self.markFlag = false
        self.markedMinePosition = NSMutableArray()
        self.checkedPoint = NSMutableArray()
        
        self.initView()
        self.setLabel()
    }
    
    //设置label
    func setLabel(){
        self.mineLabel = UILabel(frame: CGRect(x: 10, y: Width-10, width: 300, height: 20))
        self.addSubview(self.mineLabel!)
        self.showLabel()
    }
    
    //显示label
    func showLabel(){
        self.mineLabel?.text = "总雷数量／标记数量：" + String(self.minePosition!.count) + "/" + String(self.markedMinePosition!.count)
    }
    
    //初始化雷区
    fileprivate func initView(){
        let _width = self.frame.width / CGFloat(self.count!)
        
        for i in 0 ..< self.count! {
            for j in 0 ..< self.count! {
                let x = _width * CGFloat(j)
                let y = _width * CGFloat(i)
                let mine = UIButton(frame: CGRect(x: x, y: y, width: _width, height: _width))
                mine.backgroundColor = UIColor.lightGray
                mine.layer.borderWidth = 0.5
                mine.layer.borderColor = UIColor.darkGray.cgColor
                mine.tag = MineCalculate.mineSetTag(i, j: j) //设置坐标tag
                mine.setTitleColor(UIColor.black, for: UIControlState())
                mine.addTarget(self, action: #selector(self.tap), for: .touchUpInside)
                self.allMineView!.addSubview(mine)
            }
        }
    }
    
    //点击框时变颜色，或者是标记
    @objc fileprivate func tap(_ sender: UIButton){
        let mine = sender
        
        guard mine.titleLabel?.text == nil else{
            return
        }
        
        if markFlag == true {
            let tag = mine.tag //标记了就取消标记，没标记就飙红
            if mine.backgroundColor == UIColor.red {
                mine.backgroundColor = UIColor.lightGray
                self.markedMinePosition!.remove(tag)
            }else{
                mine.backgroundColor = UIColor.red
                self.markedMinePosition?.add(tag)
            }
            self.showLabel() //每标记一次，更新一次label
            
        }else if markFlag == false{
            //点击雷了
            if self.minePosition!.contains(mine.tag){
                self.delegate?.GameOver()
                self.showMine() //显示雷区的雷
            }else{ //点击的不是雷，就要计算哪些应该自动显示
                self.autoShowNoMine(mine)
            }
        }
        self.isDone()   //判断是否胜利
    }
    
    //判断是否胜利
    fileprivate func isDone(){
        guard self.markedMinePosition?.count == self.minePosition?.count else{
            return
        }
        
        //排序完了之后比较
        self.minePosition?.sort(comparator: MineCalculate.mineGetSort())
        self.markedMinePosition!.sort(comparator: MineCalculate.mineGetSort())
        if self.minePosition == self.markedMinePosition{
            self.delegate?.GameVictory()
        }
    }
    
    //自动显示周围没有雷的区域
    fileprivate func autoShowNoMine(_ btn: UIButton){
        let mine = btn
        let tag = mine.tag
        let position = MineCalculate.mineGetTag(tag)
        let x = position[0]
        let y = position[1]
        
        let allRound = MineCalculate.getAllRound(x, y: y)
        let count = self.getMineCount(allRound)
        self.showMineCount(mine, count: count)
        
        //自动显示周围区域
        if count == 0 {
            self.autoCalculateMine(btn, round: allRound)
        }
    }
    
    //循环计算周围雷数量，自动显示0的
    //递归方法效率不高
    fileprivate func autoCalculateMine(_ btn: UIButton, round: [[Int]]){
        for p in round {
            if !self.checkedPoint!.contains(p) {
                self.checkedPoint!.add(p)
                let px = p[0]
                let py = p[1]
                if px>=0 && py>=0 && px<self.count! && py<self.count!{  //控制在区域内
                    if !self.isMine(px, y: py){
                        //开进程，计算数量
                        let showMineCountQueue: DispatchQueue = DispatchQueue(label: "showMineCountQueue", attributes: [])
                        showMineCountQueue.async(execute: {
                            let pbtn = self.getBtn(px, y: py)   //新位置的btn
                            let pallRound = MineCalculate.getAllRound(px, y: py)    //新位置的周围
                            let count = self.getMineCount(pallRound)    //新位置的数量
                            
                            mainQueue.async(execute: {
                                self.showMineCount(pbtn, count: count)
                                if count == 0 {
                                    self.autoCalculateMine(pbtn, round: pallRound)
                                }
                            })
                        })
                    }
                }
            }
        }
    }
    
    //显示雷数量
    fileprivate func showMineCount(_ btn: UIButton, count: Int){
        //改变颜色，显示数字
        let tag = btn.tag
        btn.backgroundColor = UIColor.white
        
        var title = String(count)
        if count == 0 { //为0时不显示
          title = " "
        }
        btn.setTitle(title, for: UIControlState())
        
        //如果包含了，就删除，比如标记了，但是不是雷我又点了
        if self.markedMinePosition!.contains(tag) {
            self.markedMinePosition!.remove(tag)
            self.showLabel() //更新一次label
        }
    }
    
    //获取周围雷的数量
    fileprivate func getMineCount(_ round: [[Int]]) -> Int{
        var count = 0   //周围雷的数量
        for p in round{
            let px = p[0]
            let py = p[1]
            if px>=0 && py>=0 && px<self.count! && py<self.count!{  //控制在区域内
                let ptag = MineCalculate.mineSetTag(px, j: py)
                if self.minePosition!.contains(ptag) {
                    count += 1
                }
            }
        }
        return count
    }
    
    //显示雷
    func showMine(){
        for sub in self.allMineView!.subviews{
            if self.minePosition!.contains(sub.tag){
                let mine = sub as! UIButton
                mine.backgroundColor = UIColor.black
            }
        }
    }
    
    //根据坐标，确定是否是雷
    fileprivate func isMine(_ x: Int, y: Int) -> Bool{
        let mineTag = MineCalculate.mineSetTag(x, j: y)
        if self.minePosition!.contains(mineTag){
            return true
        }else{
            return false
        }
    }
    
    //根据坐标，返回btn
    fileprivate func getBtn(_ x: Int, y: Int) -> UIButton{
        let tag = MineCalculate.mineSetTag(x, j: y)
        var btn = UIButton()
        for sub in self.allMineView!.subviews{
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
