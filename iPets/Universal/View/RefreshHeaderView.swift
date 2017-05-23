//
//  MyRefreshView.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/15.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

enum RefreshState{
    case  refreshStateNormal
    case  refreshStatePulling
    case  refreshStateLoading
}

let RefreshHeaderHeight: CGFloat = 64

class RefreshHeaderView: UIView, UIScrollViewDelegate{

    var refreshState: RefreshState?
    fileprivate var delegate : isRefreshingDelegate?
    
    fileprivate var headerView: UIView! //顶部刷新view
    fileprivate var titleLabel: UILabel!
    fileprivate var scrollView: UIScrollView!
    fileprivate var actView: UIActivityIndicatorView?
    fileprivate var arrowImage: UIImageView?
    
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
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentOffset"){
            scrollViewContentOffsetDidChange(scrollView);
        }
    }
    
    func initUI(){
        
        headerView = UIView(frame: CGRect(x: 0, y: -RefreshHeaderHeight, width: scrollView.frame.width, height: RefreshHeaderHeight))
        headerView.backgroundColor = UIColor.clear
        scrollView.addSubview(headerView)
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.text = "下拉刷新"
        
        actView = UIActivityIndicatorView()
        actView?.color = UIColor.gray
        
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
    func scrollViewContentOffsetDidChange(_ scrollView: UIScrollView) {
        
        if(dragHeight() < 0 || refreshState == RefreshState.refreshStateLoading ){
            return
        }else{
            if(scrollView.isDragging){
                if(dragHeight() < RefreshHeaderHeight){
                    setRrefreshState(.refreshStateNormal)
                }else{
                    setRrefreshState(.refreshStatePulling)
                }
            }else{
                if(refreshState == RefreshState.refreshStatePulling){
                    setRrefreshState(.refreshStateLoading)
                }
            }
        }
    }
    
    //刷新状态变换
    func setRrefreshState(_ state: RefreshState){
        
        refreshState = state
        switch state{
        case .refreshStateNormal:
            
            arrowImage?.isHidden = false
            actView?.stopAnimating()
            titleLabel?.text = "下拉刷新"
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.arrowImage?.transform  = CGAffineTransform.identity
            })
            break
        case .refreshStatePulling:
            titleLabel?.text = "松开刷新"
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.arrowImage?.transform  = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            })
            break
        case .refreshStateLoading:
            titleLabel?.text = "正在刷新"
            arrowImage?.isHidden = true
            actView?.startAnimating()
            self.delegate?.reFreshing()
            break
        }
    }
    
    fileprivate func dragHeight()->CGFloat{
        return  (scrollView.contentOffset.y + scrollView.contentInset.top) *  -1.0;
    }
    
    func endRefresh(){
        setRrefreshState(.refreshStateNormal)
    }
}

