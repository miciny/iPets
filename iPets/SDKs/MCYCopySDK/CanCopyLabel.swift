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


class CanCopyLabel: UILabel {
    
    override var canBecomeFirstResponder: Bool { return true }
    private var menu: UIMenuController?
    private var isLongPressed: Bool?
    
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
        isLongPressed = false
        NotificationCenter.default.addObserver(self, selector: #selector(menuWillHide), name: NSNotification.Name.UIMenuControllerWillHideMenu, object: nil)
        
        isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(clickLabel))
        longPress.minimumPressDuration = 0.3
        self.addGestureRecognizer(longPress)
    }
    
    
    func clickLabel() {
        
        guard isLongPressed == false else {
            return
        }
        
        isLongPressed = true
        self.copyLabelDelegate?.lbLongPressed()  //已经长按
        
        // 让其成为响应者
        becomeFirstResponder()
        
        // 拿出菜单控制器单例
        menu = UIMenuController.shared
        // 创建一个复制的item
        let copy = UIMenuItem(title: "复制", action: #selector(copyText))
        let delete = UIMenuItem(title: "删除", action: #selector(deleteText))
        let share = UIMenuItem(title: "分享", action: #selector(shareText))
        
        // 将复制的item交给菜单控制器（菜单控制器其实可以接受多个操作）
        menu?.menuItems = [copy, delete, share]
        // 设置菜单控制器的点击区域为这个控件的bounds
        menu?.setTargetRect(bounds, in: self)
        // 显示菜单控制器，默认是不可见状态
        menu?.setMenuVisible(true, animated: true)
    }
    
    func menuWillHide(){
        self.resignFirstResponder()
        isLongPressed = false
        self.copyLabelDelegate?.lbNoPressed()
    }
    
    
    //复制
    func copyText() {
        UIPasteboard.general.string = self.text
        ToastView().showToast("复制成功！")
    }
    
    //删除
    func deleteText() {
       
    }
    
    //分享
    func shareText() {
        
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyText) || action == #selector(deleteText) || action == #selector(shareText) {
            return true
        }else {
            return false
        }
    }
}
