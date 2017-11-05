//
//  CanCopyImage.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/6.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

protocol CanCopyImageDelegate {
    func imageLongPressed()  //已经长按
    
    func imageNoPressed()  //弹层消失
    
    func shareImageCCV(image: UIImage)
}


class CanCopyImageView: UIImageView {
    
    override var canBecomeFirstResponder: Bool { return true }
    private var menu: UIMenuController?
    private var isLongPressed: Bool?
    
    var copyImageDelegate: CanCopyImageDelegate?
    
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
    
    
    @objc func clickLabel() {
        
        guard isLongPressed == false else {
            return
        }
        
        isLongPressed = true
        self.copyImageDelegate?.imageLongPressed()  //已经长按
        
        // 让其成为响应者
        becomeFirstResponder()
        
        // 拿出菜单控制器单例
        menu = UIMenuController.shared
        // 创建一个复制的item
        let copy = UIMenuItem(title: "收藏", action: #selector(collect))
        let delete = UIMenuItem(title: "删除", action: #selector(deleteImage))
        let share = UIMenuItem(title: "分享", action: #selector(shareImage))
        
        // 将复制的item交给菜单控制器（菜单控制器其实可以接受多个操作）
        menu?.menuItems = [copy, delete, share]
        // 设置菜单控制器的点击区域为这个控件的bounds
        menu?.setTargetRect(bounds, in: self)
        // 显示菜单控制器，默认是不可见状态
        menu?.setMenuVisible(true, animated: true)
    }
    
    @objc func menuWillHide(){
        self.resignFirstResponder()
        isLongPressed = false
        self.copyImageDelegate?.imageNoPressed()
    }
    
    
    //复制
    @objc func collect() {
    }
    
    //删除
    @objc func deleteImage() {
        
    }
    
    //分享
    @objc func shareImage() {
        self.copyImageDelegate?.shareImageCCV(image: self.image!)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(collect) || action == #selector(deleteImage) || action == #selector(shareImage) {
            return true
        }else {
            return false
        }
    }
}
