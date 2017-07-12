//
//  MansAreaView.swift
//  Roll
//
//  Created by maocaiyuan on 2017/1/13.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class MansAreaView: UIView {
    
    fileprivate var realManArray: NSMutableArray?

    //设置
    init(frame: CGRect, y: CGFloat, realManArray: NSMutableArray){
        super.init(frame: frame)
        
        self.frame.size = CGSize(width: Width-40, height: Height-RollConstans._width-40)
        self.frame.origin = CGPoint(x: 20, y: y)
        
        self.realManArray = realManArray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //显示头像
    func showMansIcon(){
        let count = self.realManArray!.count
        let gap = CGFloat(10)
        var maxY = CGFloat(0)
        
        for i in 0 ..< count {
            let man = RollViewLike.iconImageView()
            let originX = CGFloat(Int(i%4)) * (RollConstans._width + gap)
            let originY = CGFloat(Int(i/4)) * (RollConstans._width + gap)
            man.frame.origin = CGPoint(x: originX, y: originY)
            
            let manId = self.realManArray![i]
            man.image = UIImage(named: "icon_"+String(describing: manId)+".JPG")
            self.addSubview(man)
            
            man.tag = i
            maxY = man.frame.maxY
        }
        self.frame.size.height = maxY //中奖区的高度确定
    }
    
    
    //给头像添加点击事件
    func selectManEvent(){
        let subViews = self.subviews
        
        for sub in subViews{
            let icon = sub as! UIImageView
            icon.layer.borderColor = UIColor.darkGray.cgColor
            icon.layer.borderWidth = 5
            
            icon.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapMan))
            icon.addGestureRecognizer(tap)
        }
    }
    
    //点击人头像事件
    func tapMan(_ sender: UITapGestureRecognizer){
        let view = sender.view as! UIImageView
        let tag = view.tag
        
        if self.realManArray!.contains(tag){
            view.layer.borderColor = UIColor.darkGray.cgColor
            self.realManArray!.remove(tag)
            
            self.deleteNo(view)
            self.resetNo(self.realManArray!)
            RollViewLike.stopAnim(view) //停止动画
        }else{
            view.layer.borderColor = UIColor.red.cgColor
            self.realManArray!.add(tag)
            
            let no = self.realManArray!.index(of: tag)
            self.addNo(view, no: no+1) // 添加序号
            RollViewLike.starAnim(view)  //动画
        }
    }
    
    //头像选中
    func manSelected(_ index: Int){
        let subViews = self.subviews
        
        for sub in subViews{
            let icon = sub as! UIImageView
            if index == sub.tag{
                icon.layer.borderWidth = 5
                icon.layer.borderColor = UIColor.red.cgColor
            }else{
                icon.layer.borderWidth = 0
                icon.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    //循环选择头像动画
    func forSelectIcon(_ count: Int, roll: Int, task: @escaping ()->()?){
        
        let rollQueue: DispatchQueue = DispatchQueue(label: "rollQueue", attributes: [])
        for j in 0 ... roll{
            if j > roll-5{    //后五次慢点
                rollQueue.async(execute: {
                    Thread.sleep(forTimeInterval: 0.15*Double(5-roll+j))
                    mainQueue.async(execute: {
                        self.manSelected(j%count)
                        if j == roll{
                            task()
                        }
                    })
                })
            }else{
                rollQueue.async(execute: {
                    Thread.sleep(forTimeInterval: 0.1)
                    mainQueue.async(execute: {
                        self.manSelected(j%count)
                    })
                })
            }
        }
    }
    
    //删除所有人的头像
    func deleteAllIcon(){
        let subViews = self.subviews
        for sub in subViews{
            sub.removeFromSuperview()
        }
    }
    
    //删除序号
    func deleteNo(_ view: UIImageView!){
        let subs = view.subviews
        for sub in subs {
            if sub.isKind(of: UILabel.self) {
                sub.removeFromSuperview()
            }
        }
    }
    
    //重新排序
    func resetNo(_ realManArray: NSMutableArray){
        let subViews = self.subviews
        
        for sub in subViews{
            let icon = sub as! UIImageView
            if  realManArray.contains(sub.tag){
                self.deleteNo(icon)  //先删掉原来的数字
                
                let no = realManArray.index(of: sub.tag)
                addNo(icon, no: no+1)
            }
        }
    }
    
    //点击图片，添加序号
    func addNo(_ view: UIImageView!, no: Int){
        let lb = UILabel()
        lb.backgroundColor = UIColor.white
        lb.layer.cornerRadius = 15
        lb.layer.masksToBounds = true
        lb.text = String(no)
        lb.font = RollConstans.noFont
        lb.textColor = UIColor.red
        lb.textAlignment = .center
        lb.frame.size = CGSize(width: 30, height: 30)
        lb.frame.origin = CGPoint(x: 10, y: 10)
        view.addSubview(lb)
    }
}
