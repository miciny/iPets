//
//  LoadMoreView.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/24.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

class LoadMoreView: UIView, UIScrollViewDelegate{
    
    var loadMoreEnabled = true
    private var delegate : isLoadMoreingDelegate?
    
    private let footerView = UIView()
    private var titleLabel: UILabel!
    private var scrollView: UIScrollView!
    private var actView: UIActivityIndicatorView?
    private var arrowImage: UIImageView?
    
    init(frame: CGRect, subView: UIScrollView, target: isLoadMoreingDelegate) {
        
        super.init(frame:frame)
        scrollView = subView
        self.delegate = target
        //        scrollView.delegate = self  //如果不是设置的观察者，会出现cell显示错误的问题
        setupFooterView()
        designKFC()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置观察者
    func designKFC(){
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "contentOffset"){
            scrollViewContentOffsetDidChange(scrollView);
        }
    }
    
    //底部刷新
    private func setupFooterView(){
        
        footerView.frame = CGRectMake(0, scrollView.contentSize.height, Width, RefreshHeaderHeight)
        footerView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        footerView.backgroundColor = UIColor.clearColor()
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.systemFontOfSize(12)
        titleLabel?.textAlignment = NSTextAlignment.Center
        titleLabel?.text = "上拉加载"
        
        actView = UIActivityIndicatorView()
        actView?.color = UIColor.grayColor()
        
        arrowImage = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
        
        footerView.addSubview(titleLabel!)
        footerView.addSubview(arrowImage!)
        footerView.addSubview(actView!)
        
        /**
         *  约束
         */
        bottomSpaceToView(titleLabel, view2: footerView, constant: -15)
        centerXEqualToView(titleLabel, view2: footerView)
        widthIs(titleLabel, width: 100)
        heightIs(titleLabel, height: 30)
        
        rightSpaceToView(actView!, view2: titleLabel, constant: -10)
        bottomSpaceToView(actView!, view2: footerView, constant: -15)
        widthIs(actView!, width: 30)
        heightIs(actView!, height: 30)
        
        rightSpaceToView(arrowImage!, view2: titleLabel, constant: -10)
        bottomSpaceToView(arrowImage!, view2: footerView, constant: -15)
        widthIs(arrowImage!, width: 30)
        heightIs(arrowImage!, height: 30)
        
    }
    
    var refreshState: RefreshState?
    
    func scrollViewContentOffsetDidChange(scrollView: UIScrollView) {
        let dragHeight = scrollView.contentOffset.y
        let tableHeigt = scrollView.contentSize.height - scrollView.frame.size.height
        
        if(dragHeight < tableHeigt || refreshState == RefreshState.RefreshStateLoading ){
            return
        }else{
            if(scrollView.dragging){
                if(dragHeight < tableHeigt + RefreshHeaderHeight){
                    setRrefreshState(.RefreshStateNormal)
                }else{
                    setRrefreshState(.RefreshStatePulling)
                }
            }else{
                if(refreshState == RefreshState.RefreshStatePulling){
                    setRrefreshState(.RefreshStateLoading)
                }
            }
        }
    }
    
    func hideView(){
        footerView.removeFromSuperview()
    }
    
    func showView(){
        scrollView.addSubview(footerView)
    }
    
    //用于刷新footer的位置
    func refreshHeight(){
        footerView.frame = CGRectMake(0, scrollView.contentSize.height, Width, RefreshHeaderHeight)
    }
    //刷新状态变换
    func setRrefreshState(state: RefreshState){
        
        refreshState = state
        switch state{
        case .RefreshStateNormal:
            
            arrowImage?.hidden = false
            actView?.stopAnimating()
            titleLabel?.text = "上拉加载"
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.arrowImage?.transform  = CGAffineTransformIdentity
            })
            break
        case .RefreshStatePulling:
            titleLabel?.text = "松开加载"
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.arrowImage?.transform  = CGAffineTransformMakeRotation(CGFloat(M_PI))
            })
            break
        case .RefreshStateLoading:
            titleLabel?.text = "正在加载"
            arrowImage?.hidden = true
            actView?.startAnimating()
            self.delegate?.loadMore()
            
        }
    }
    
    func endRefresh(){
        setRrefreshState(.RefreshStateNormal)
    }
}

