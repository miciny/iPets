//
//  LoadMoreView.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/24.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit

//上拉加载更多的代理
protocol isLoadingMoreDelegate{
    func loadMore()
}

class LoadMoreView: UIView, UIScrollViewDelegate{
    
    var loadMoreEnabled = true
    fileprivate var delegate : isLoadingMoreDelegate?
    
    fileprivate let footerView = UIView()
    fileprivate var titleLabel: UILabel!
    fileprivate var scrollView: UIScrollView!
    fileprivate var actView: UIActivityIndicatorView?
    fileprivate var arrowImage: UIImageView?
    
    init(frame: CGRect, subView: UIScrollView, target: isLoadingMoreDelegate) {
        
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
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentOffset"){
            scrollViewContentOffsetDidChange(scrollView);
        }
    }
    
    //底部刷新
    fileprivate func setupFooterView(){
        
        footerView.frame = CGRect(x: 0, y: scrollView.contentSize.height, width: Width, height: RefreshHeaderHeight)
        footerView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        footerView.backgroundColor = UIColor.clear
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.text = "上拉加载"
        
        actView = UIActivityIndicatorView()
        actView?.color = UIColor.gray
        
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
    
    func scrollViewContentOffsetDidChange(_ scrollView: UIScrollView) {
        let dragHeight = scrollView.contentOffset.y
        let tableHeigt = scrollView.contentSize.height - scrollView.frame.size.height
        
        if(dragHeight < tableHeigt || refreshState == RefreshState.refreshStateLoading ){
            return
        }else{
            if(scrollView.isDragging){
                if(dragHeight < tableHeigt + RefreshHeaderHeight){
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
    
    func hideView(){
        footerView.removeFromSuperview()
    }
    
    func showView(){
        scrollView.addSubview(footerView)
    }
    
    //用于刷新footer的位置
    func refreshHeight(){
        footerView.frame = CGRect(x: 0, y: scrollView.contentSize.height, width: Width, height: RefreshHeaderHeight)
    }
    //刷新状态变换
    func setRrefreshState(_ state: RefreshState){
        
        refreshState = state
        switch state{
        case .refreshStateNormal:
            
            arrowImage?.isHidden = false
            actView?.stopAnimating()
            titleLabel?.text = "上拉加载"
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.arrowImage?.transform  = CGAffineTransform.identity
            })
            break
        case .refreshStatePulling:
            titleLabel?.text = "松开加载"
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.arrowImage?.transform  = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            })
            break
        case .refreshStateLoading:
            titleLabel?.text = "正在加载"
            arrowImage?.isHidden = true
            actView?.startAnimating()
            self.delegate?.loadMore()
            
        }
    }
    
    func endRefresh(){
        setRrefreshState(.refreshStateNormal)
    }
}

