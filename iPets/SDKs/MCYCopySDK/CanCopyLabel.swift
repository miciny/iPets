//
//  CanCopyLabel.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/6.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

protocol CanCopyLabelDelegate {
    func lbLongPressed()  //已经长按
    
    func lbNoPressed()  //弹层消失
}

enum CanCopyLabelFrom{
    case chat
    case find
}

class CanCopyLabel: UILabel {
    
    override var canBecomeFirstResponder: Bool { return true }
    private var menu: UIMenuController?
    private var isLongPressed: Bool?
    
    var canCopyLabelFrom: CanCopyLabelFrom?
    var copyLabelDelegate: CanCopyLabelDelegate?
    
    // 代码创建控件的时候有效
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // storyboard或xib创建控件的时候有效
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    // 让其有交互能力，并添加一个长按手势
    func setup() {
        
        //必须先设置它才显示
        
        isLongPressed = false
        NotificationCenter.default.addObserver(self, selector: #selector(menuWillHide), name: NSNotification.Name.UIMenuControllerWillHideMenu, object: nil)
        
        isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(clickLabel))
        longPress.minimumPressDuration = 0.3
        self.addGestureRecognizer(longPress)
    }
    
    
    @objc func clickLabel() {
        
        guard isLongPressed == false else {
            return
        }
        guard canCopyLabelFrom != nil else {
            return
        }
        
        isLongPressed = true
        // 让其成为响应者
        becomeFirstResponder()
        // 拿出菜单控制器单例
        menu = UIMenuController.shared
        
        switch self.canCopyLabelFrom! {
        case .chat:
            self.copyLabelDelegate?.lbLongPressed()  //已经长按
            // 创建一个复制的item
            let copy = UIMenuItem(title: "复制", action: #selector(copyText))
            let delete = UIMenuItem(title: "删除", action: #selector(deleteText))
            let share = UIMenuItem(title: "分享", action: #selector(shareText))
            // 将复制的item交给菜单控制器（菜单控制器其实可以接受多个操作）
            menu?.menuItems = [copy, delete, share]
            
        case .find:
            self.backgroundColor = UIColor.lightGray
            // 创建一个复制的item
            let copy = UIMenuItem(title: "复制", action: #selector(copyText))
            let collect = UIMenuItem(title: "收藏", action: #selector(collectThis))
            menu?.menuItems = [copy, collect]
        }
        
        // 设置菜单控制器的点击区域为这个控件的bounds
        menu?.setTargetRect(bounds, in: self)
        // 显示菜单控制器，默认是不可见状态
        menu?.setMenuVisible(true, animated: true)
    }
    
    @objc func menuWillHide(){
        self.resignFirstResponder()
        isLongPressed = false
        
        switch self.canCopyLabelFrom! {
        case .chat:
            self.copyLabelDelegate?.lbNoPressed()
            
        case .find:
            self.backgroundColor = UIColor.clear
        }
    }
    
    
    //复制
    @objc func copyText() {
        UIPasteboard.general.string = self.text
        ToastView().showToast("复制成功！")
    }
    
    //删除
    @objc func deleteText() {
       
    }
    
    //分享
    @objc func shareText() {
        
    }
    
    //收藏
    @objc func collectThis(){
        
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyText) ||
            action == #selector(deleteText) ||
            action == #selector(shareText) ||
            action == #selector(collectThis){
            return true
        }else {
            return false
        }
    }
}
