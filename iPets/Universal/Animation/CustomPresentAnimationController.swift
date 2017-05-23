//
//  PresentAndDismissAnimation.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/17.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        
        let bounds = UIScreen.main.bounds
        toViewController.view.frame = finalFrameForVC.offsetBy(dx: bounds.size.width, dy: 0) //从这里调节左右进入
        
        containerView.addSubview(toViewController.view)
        
        //动画本体
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            fromViewController.view.alpha = 1.0
            toViewController.view.frame = finalFrameForVC
            
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
                fromViewController.view.alpha = 1.0
        })
        
        
    }
}
