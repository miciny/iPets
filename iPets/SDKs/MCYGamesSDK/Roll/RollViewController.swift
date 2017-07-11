//
//  RollViewController.swift
//  iPets
//
//  Created by maocaiyuan on 2017/7/7.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class RollViewController: UIViewController {

    var selectManBtn: UIButton?  //选择人员的按钮
    var iconView: MansAreaView?
    var prizeView: PrizeAreaView?
    var resetBtn: UIBarButtonItem?
    var mainScroll: UIScrollView?
    
    var realManArray: NSMutableArray?  //真实抽奖的人
    var selectedManArray: NSMutableArray?  //中奖的人
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.realManArray = NSMutableArray() //选择完的人
        self.selectedManArray = NSMutableArray() //选择的人
        
        self.setUpTitle()
        self.setUpEles()
        
        self.setUpMansIcon()
    }
    
    func setUpTitle(){
        self.title = "Uno"
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = RollViewLike.getNoStr()  //标题为识别码
        
        self.resetBtn = UIBarButtonItem(title: "重置", style: .plain, target: self, action:
            #selector(resetAll))
        self.navigationItem.rightBarButtonItem = self.resetBtn
        
        self.mainScroll = RollViewLike.setUpScrollView()  //滚动页面
        self.view.addSubview(self.mainScroll!)
    }
    
    //重制功能
    func resetAll(){
        self.realManArray?.removeAllObjects()
        self.selectedManArray?.removeAllObjects()
        self.prizeView = nil
        
        //删除原先的元素
        for sub in self.mainScroll!.subviews{
            sub.removeFromSuperview()
        }
        
        self.setUpEles()
        self.setUpMansIcon()
        
        self.navigationItem.title = RollViewLike.getNoStr()
    }
    
//********************************************************按钮************************************************
    //按钮类
    func setUpEles(){
        self.selectManBtn = RollViewLike.myBtn("选择参加人员", color: UIColor.red)
        self.selectManBtn!.addTarget(self, action: #selector(selectManEvent), for: .touchUpInside)
        self.mainScroll!.addSubview(selectManBtn!)
    }
    
    //选人事件
    func selectManEvent(){
        self.realManArray!.removeAllObjects()
        self.setSelectBtnToDone()
        self.iconView!.selectManEvent()
    }
    
    
    //选人按钮 点击后变成完成按钮
    func setSelectBtnToDone(){
        self.selectManBtn!.setTitle("完成", for: UIControlState())
        self.selectManBtn!.removeTarget(self, action: #selector(forSelectedMan), for: .touchUpInside)
        self.selectManBtn!.addTarget(self, action: #selector(selectDone), for: .touchUpInside)
    }
    
    //选人结束变成开始按钮
    func selectDone(){
        
        self.showPrizeArea()
        self.setUpMansIcon() //选完人结束后，需要重新显示区域
        
        self.selectManBtn!.setTitle("开始", for: UIControlState())
        self.selectManBtn!.removeTarget(self, action: #selector(selectDone), for: .touchUpInside)
        self.selectManBtn!.addTarget(self, action: #selector(forSelectedMan), for: .touchUpInside)
    }
    
    //开始按钮置灰
    func setSelectBtnUnable(){
        self.resetBtn!.isEnabled = false
        self.selectManBtn!.isEnabled = false
        self.selectManBtn!.backgroundColor = UIColor.lightGray
    }
    
    //开始按钮可点
    func setSelectBtnEnable(){
        self.resetBtn!.isEnabled = true
        self.selectManBtn!.isEnabled = true
        self.selectManBtn!.backgroundColor = UIColor.red
    }
    
//********************************************************两个区域************************************************
    //中奖区
    func showPrizeArea(){
        self.selectedManArray?.removeAllObjects()
        self.prizeView = PrizeAreaView(frame: CGRect.zero, color: UIColor.red)
        self.mainScroll!.addSubview(self.prizeView!)
    }
    
    //人员的头像显示
    func setUpMansIcon(){
        
        //一开始不现实中奖区域，要判断下
        let y = isShowPrizeArea()
        
        //头像区没有就新建 有就删除所有的
        if self.iconView == nil{
            self.iconView = MansAreaView(frame: CGRect.zero, y: y+10, realManArray: self.realManArray!)
        }else{
            self.iconView!.frame.origin.y = y+10
            self.iconView!.deleteAllIcon()
        }
        self.mainScroll!.addSubview(self.iconView!)
        
        //没有选择人的话，就是选择所有人
        if self.realManArray!.count == 0{
            self.realManArray!.addObjects(from: RollConstans.manNoArrar)
        }
        
        self.iconView!.showMansIcon()
        
        let iconViewHeight = self.iconView!.frame.height
        self.mainScroll!.contentSize = CGSize(width: Width, height: iconViewHeight+y+49)  //滚动高度
        self.selectManBtn!.frame.origin = CGPoint(x: 20, y: self.iconView!.frame.maxY+20) //按钮高度
    }
    
    //判断下有没有显示中奖区域，返回一个y
    func isShowPrizeArea() -> CGFloat{
        var y = CGFloat(0)
        if self.prizeView != nil{
            y = (self.prizeView?.frame.maxY)!
        }
        return y
    }
    
    //显示中奖头像
    func showPrizeIcon(){
        self.prizeView?.showPrizeIcon(self.prizeView!, selectedManArray: self.selectedManArray!)
    }
    
    //循环选择头像
    func forSelectedMan(){
        
        let count = self.realManArray!.count
        if count == 1 {  //只有一个时，就不能选择了
            return
        }
        
        self.setSelectBtnUnable()
        
        let theMan = RollViewLike.cheat(count, realManArray: self.realManArray!)
        let index = self.realManArray![theMan] as! Int
        let rollNo = theMan + count * 2  //增加循环次数
        
        self.iconView?.forSelectIcon(count, roll: rollNo, task: { () -> ()? in
            self.selected(index)
        })
    }
    
    //动画完了的延迟动作
    func selected(_ index: Int){
        let _ = delay(0.6, task: {
            self.selectedManArray!.add(index)
            self.showPrizeIcon()  //
            self.realManArray!.remove(index)
            self.setUpMansIcon()
            self.setSelectBtnEnable()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
