//
//  AutoLayout.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/16.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

//宽度约束
func widthIs(view: UIView, width: CGFloat){
    view.translatesAutoresizingMaskIntoConstraints = false
    let widthIs: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: width)
    view.addConstraint(widthIs)
}

//高度约束
func heightIs(view: UIView, height: CGFloat){
    view.translatesAutoresizingMaskIntoConstraints = false
    let heightIs: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: height)
    view.addConstraint(heightIs)
}

//中心X坐标约束
func centerXEqualToView(view1: UIView, view2: UIView){
    view1.translatesAutoresizingMaskIntoConstraints = false
    let centerXEqualToView: NSLayoutConstraint = NSLayoutConstraint(
        item: view1, attribute: .CenterX , relatedBy: .Equal,
        toItem: view2, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
    
    if(view1.superview == view2){
        view2.addConstraint(centerXEqualToView)
    }else{
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.superview!.addConstraint(centerXEqualToView)
    }
    
}

//底部宽度约束
func bottomSpaceToView(view1: UIView, view2: UIView, constant: CGFloat){
    view1.translatesAutoresizingMaskIntoConstraints = false
    let bottomSpaceToView: NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: .Bottom, relatedBy: .Equal, toItem: view2, attribute: .Bottom, multiplier: 1, constant: constant)
    
    if(view1.superview == view2){
        view2.addConstraint(bottomSpaceToView)
    }else{
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.superview!.addConstraint(bottomSpaceToView)
    }
    
}

//右侧与view2的宽度的约束
func rightSpaceToView(view1: UIView, view2: UIView, constant: CGFloat){
    view1.translatesAutoresizingMaskIntoConstraints = false
    let rightSpaceToView: NSLayoutConstraint = NSLayoutConstraint(
        item: view1, attribute: .Right , relatedBy: .Equal,
        toItem: view2, attribute: .Left, multiplier: 1.0, constant: constant)
    
    if(view1.superview == view2){
        view2.addConstraint(rightSpaceToView)
    }else{
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.superview!.addConstraint(rightSpaceToView)
    }
}



