//
//  MyRefreshView.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/15.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

enum RefreshState{
    case  RefreshStateNormal
    case  RefreshStatePulling
    case  RefreshStateLoading
}

let RefreshHeaderHeight: CGFloat = 64

class RefreshHeaderView: UIView, UIScrollViewDelegate{

    var refreshState: RefreshState?
    private var delegate : isRefreshingDelegate?
    
    private var headerView: UIView! //顶部刷新view
    private var titleLabel: UILabel!
    private var scrollView: UIScrollView!
    private var actView: UIActivityIndicatorView?
    private var arrowImage: UIImageView?
    
    init(frame: CGRect, subView: UIScrollView, target: isRefreshingDelegate){
        
        super.init(frame:frame)
        scrollView = subView
        self.delegate = target
//        scrollView.delegate = self  //如果不是设置的观察者，会出现cell显示错误的问题
        initUI()
        designKFC()
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
    
    func initUI(){
        
        headerView = UIView(frame: CGRectMake(0, -RefreshHeaderHeight, scrollView.frame.width, RefreshHeaderHeight))
        headerView.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(headerView)
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.systemFontOfSize(12)
        titleLabel?.textAlignment = NSTextAlignment.Center
        titleLabel?.text = "下拉刷新"
        
        actView = UIActivityIndicatorView()
        actView?.color = UIColor.grayColor()
        
        arrowImage = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
        
        headerView.addSubview(titleLabel!)
        headerView.addSubview(arrowImage!)
        headerView.addSubview(actView!)
        
        /**
        *  约束
        */
        
        bottomSpaceToView(titleLabel, view2: headerView, constant: -15)
        centerXEqualToView(titleLabel, view2: headerView)
        widthIs(titleLabel, width: 100)
        heightIs(titleLabel, height: 30)
        
        rightSpaceToView(actView!, view2: titleLabel, constant: -10)
        bottomSpaceToView(actView!, view2: headerView, constant: -15)
        widthIs(actView!, width: 30)
        heightIs(actView!, height: 30)
        
        rightSpaceToView(arrowImage!, view2: titleLabel, constant: -10)
        bottomSpaceToView(arrowImage!, view2: headerView, constant: -15)
        widthIs(arrowImage!, width: 30)
        heightIs(arrowImage!, height: 30)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    func scrollViewContentOffsetDidChange(scrollView: UIScrollView) {
        
        if(dragHeight() < 0 || refreshState == RefreshState.RefreshStateLoading ){
            return
        }else{
            if(scrollView.dragging){
                if(dragHeight() < RefreshHeaderHeight){
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
    
    //刷新状态变换
    func setRrefreshState(state: RefreshState){
        
        refreshState = state
        switch state{
        case .RefreshStateNormal:
            
            arrowImage?.hidden = false
            actView?.stopAnimating()
            titleLabel?.text = "下拉刷新"
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.arrowImage?.transform  = CGAffineTransformIdentity
            })
            break
        case .RefreshStatePulling:
            titleLabel?.text = "松开刷新"
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.arrowImage?.transform  = CGAffineTransformMakeRotation(CGFloat(M_PI))
            })
            break
        case .RefreshStateLoading:
            titleLabel?.text = "正在刷新"
            arrowImage?.hidden = true
            actView?.startAnimating()
            self.delegate?.reFreshing()
            break
        }
    }
    
    private func dragHeight()->CGFloat{
        return  (scrollView.contentOffset.y + scrollView.contentInset.top) *  -1.0;
    }
    
    func endRefresh(){
        setRrefreshState(.RefreshStateNormal)
    }
}

