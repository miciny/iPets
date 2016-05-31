//
//  PresentAndDismissAnimation.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/17.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        let containerView = transitionContext.containerView()
        
        let bounds = UIScreen.mainScreen().bounds
        toViewController.view.frame = CGRectOffset(finalFrameForVC, bounds.size.width, 0) //从这里调节左右进入
        
        containerView!.addSubview(toViewController.view)
        
        //动画本体
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            
            fromViewController.view.alpha = 1.0
            toViewController.view.frame = finalFrameForVC
            
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
                fromViewController.view.alpha = 1.0
        })
        
        
    }
}
