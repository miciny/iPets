//
//  MyMenuView.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/5.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

// 显示底部菜单
class MyBottomMenuView: UIView{
    
    var delegate : bottomMenuViewDelegate?
    var isShowingMenu = false  //是否正在显示
    
    fileprivate var eventFlag = Int() //一个界面多次调用时，进行的判断，可以传入按钮的tag等
    
    var objectHeight : CGFloat = 60 //每个菜单的高度高度
    var titleHeight : CGFloat = 60
    var cancelHeight : CGFloat = 60
    
    var titleFont : CGFloat = 20
    var titleColor = UIColor.gray
    
    var cancelFont : CGFloat = 20
    var cancelColor = UIColor.black
    
    var objectFont : CGFloat = 20
    var objectColor = UIColor.black
    
    var mainView : UIControl!
    let buttonView = UIView()
    
    let Height = UIScreen.main.bounds.height
    let Width = UIScreen.main.bounds.width
    
    var centerPosition = CGPoint()
    
    fileprivate var title: String!
    fileprivate var cancel: String!
    fileprivate var object: NSArray!
    final let gap : CGFloat = 7  // 取消与上面按钮的间隔
    
    func showBottomMenu(_ title: String, cancel: String, object: NSArray, eventFlag: Int ,target: bottomMenuViewDelegate){
        self.title = title
        self.cancel = cancel
        self.object = object
        
        centerPosition = CGPoint(x: Width/2, y: Height/2)
        let totalHeight = calculateheight()
        
        self.frame = CGRect(x: 0, y: 0, width: Width, height: Height)
        self.backgroundColor = UIColor.clear  //背景色
        self.isOpaque = true
        self.alpha = 1
        self.eventFlag = eventFlag
        self.delegate = target
        
        buttonView.frame = CGRect(x: 0, y: Height-totalHeight , width: Width, height: totalHeight)
        buttonView.backgroundColor = UIColor.white
        buttonView.alpha = 1
        
        if(title != ""){
            setTitle()
        }
        
        if(cancel != ""){
            setCancel(totalHeight)
        }
        
        if(object.count > 0){
            let lineW : CGFloat = 0.5
            for i in 0 ..< object.count{
                
                let cancelLine = UIView(frame: CGRect(x: 0, y: titleHeight + CGFloat(i) * objectHeight, width: Width, height: lineW))
                cancelLine.backgroundColor = UIColor.black
                cancelLine.alpha = 0.6
                buttonView.addSubview(cancelLine)
                
                let objectBtn = UIButton(frame: CGRect(x: 0, y: titleHeight + CGFloat(i) * objectHeight + lineW, width: Width, height: objectHeight-lineW))
                objectBtn.backgroundColor = UIColor.white
                objectBtn.setTitle(object[i] as? String, for: UIControlState())
                objectBtn.titleLabel?.font = UIFont.systemFont(ofSize: objectFont)
                objectBtn.setTitleColor(objectColor, for: UIControlState())
                objectBtn.addTarget(self, action: #selector(MyBottomMenuView.buttonClicked(_:)), for: .touchUpInside)
                objectBtn.tag = i //标示
                buttonView.addSubview(objectBtn)
            }
        }
        
        addRemoveBtn()
        
        //为什么用uicontroller加，我也不知道
        if mainView == nil {
            mainView = UIControl(frame: UIScreen.main.bounds)
            mainView.backgroundColor = UIColor.clear
            mainView.addSubview(self)
            self.center = CGPoint(x: centerPosition.x, y: centerPosition.y)
            mainView.alpha = 1
            
            UIApplication.shared.keyWindow?.addSubview(self.mainView)
            
            self.addSubview(buttonView)
            self.buttonView.layer.add(presentAnimation(), forKey: "")
        }
        
        self.isShowingMenu = true
    }
    
    //计算总高度
    func calculateheight() -> CGFloat{
        var totalHeight : CGFloat = 0 //总高度
        let osHeight = CGFloat(self.object.count) * self.objectHeight
        
        if(self.title == "" && self.cancel == ""){
            titleHeight = 0
            cancelHeight = 0
            totalHeight = osHeight + gap
        }else if(self.title == "" && self.cancel != ""){
            titleHeight = 0
            totalHeight = osHeight + gap + cancelHeight
        }else if(self.title != "" && self.cancel == ""){
            cancelHeight = 0
            totalHeight = osHeight + titleHeight + gap
        }else{
            totalHeight = osHeight + titleHeight + gap + cancelHeight //总高度
        }
        
        return totalHeight
    }
    
    //设置cancel按钮
    func setCancel(_ totalHeight: CGFloat){
        let cancelLine = UIView(frame: CGRect(x: 0, y: totalHeight-cancelHeight-gap, width: Width, height: gap))
        cancelLine.backgroundColor = UIColor.gray
        cancelLine.alpha = 0.6
        buttonView.addSubview(cancelLine)
        
        let cancelBtn = UIButton(frame: CGRect(x: 0, y: totalHeight-cancelHeight, width: Width, height: cancelHeight))
        cancelBtn.backgroundColor = UIColor.white
        cancelBtn.setTitle(self.cancel, for: UIControlState())
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: cancelFont)
        cancelBtn.setTitleColor(cancelColor, for: UIControlState())
        cancelBtn.addTarget(self, action: #selector(MyBottomMenuView.hideView), for: .touchUpInside)
        buttonView.addSubview(cancelBtn)
    }
    
    //设置title按钮
    func setTitle(){
        let titleLb = UILabel(frame: CGRect(x: 0, y: 0, width: Width, height: titleHeight))
        titleLb.backgroundColor = UIColor.white
        titleLb.text = self.title
        titleLb.textAlignment = .center
        titleLb.font = UIFont.systemFont(ofSize: titleFont)
        titleLb.textColor = titleColor
        buttonView.addSubview(titleLb)
    }
    
    //在整个页面的空余地方添加一个button，点击移除view
    func addRemoveBtn(){
        let removeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
        removeBtn.backgroundColor = UIColor.black
        removeBtn.alpha = 0.5
        removeBtn.addTarget(self, action: #selector(MyBottomMenuView.hideView), for: .touchUpInside)
        self.addSubview(removeBtn)
    }
    
    // 显示的动画
    func presentAnimation() -> CATransition{
        let animation = CATransition()
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromTop
        animation.duration = 0.2
        
        return animation
    }
    
    //隐藏view
    func hideView(){
        UIView.animate(withDuration: 0.2, animations: {
            () -> ()in
            self.buttonView.frame = CGRect(x: 0, y: self.Height, width: self.Width, height: self.buttonView.frame.height)
            }, completion: {
                (Boolean) -> ()in
                self.mainView.removeFromSuperview()
                self.isShowingMenu = false
        })
    }
    
    //点击按钮 事件
    func buttonClicked(_ sender : UIButton){
        hideView()
        let oBtn = sender as UIButton
        self.delegate?.buttonClicked(oBtn.tag, eventFlag: self.eventFlag)
    }
    
}
