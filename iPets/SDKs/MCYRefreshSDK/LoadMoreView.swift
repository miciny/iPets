//
//  LoadMoreView.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/24.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import UIKit
import Cartography

//上啦加载更多
protocol isLoadMoreDelegate {
    func loadingMore()
}

class LoadMoreView: UIView, UIScrollViewDelegate{
    
    var loadMoreEnabled = true
    fileprivate var delegate: isLoadMoreDelegate?
    let LoadMoreHeaderHeight: CGFloat = 50
    
    fileprivate let footerView = UIView()
    fileprivate var titleLabel: UILabel!
    fileprivate var scrollView: UIScrollView!
    fileprivate var actView: UIActivityIndicatorView?
    fileprivate var arrowImage: UIImageView?
    
    init(frame: CGRect, subView: UIScrollView, target: isLoadMoreDelegate) {
        
        super.init(frame:frame)
        scrollView = subView
        self.delegate = target
        setupFooterView()
        designKFC()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置观察者
    func designKFC(){
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height+LoadMoreHeaderHeight)
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentOffset"){
            scrollViewContentOffsetDidChange(scrollView);
        }
    }
    
    func removeOberver(){
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    //底部刷新
    fileprivate func setupFooterView(){
        
        footerView.frame = CGRect(x: 0, y: scrollView.contentSize.height, width: Width, height: LoadMoreHeaderHeight)
        footerView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        footerView.backgroundColor = UIColor.clear
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.text = "上拉加载"
        
        actView = UIActivityIndicatorView()
        actView?.color = UIColor.gray
        
        arrowImage = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
        self.arrowImage?.transform  = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        footerView.addSubview(titleLabel!)
        footerView.addSubview(arrowImage!)
        footerView.addSubview(actView!)
        
        /**
         *  约束
         */
        
        constrain(titleLabel, footerView) { (view, view1) in
            view.bottom == view1.bottom - 15
            view.centerX == view1.centerX
            view.width == 100
            view.height == 30
        }
        
        constrain(actView!, titleLabel, footerView) { (view, view1, view2) in
            view.right == view1.left + 10
            view.bottom == view2.bottom - 15
            view.width == 30
            view.height == 30
        }
        
        constrain(arrowImage!, titleLabel, footerView) { (view, view1, view2) in
            view.right == view1.left + 10
            view.bottom == view2.bottom - 15
            view.width == 30
            view.height == 30
        }
        
    }
    
    var refreshState: RefreshState?
    
    func scrollViewContentOffsetDidChange(_ scrollView: UIScrollView) {
        
        let dragHeight = scrollView.contentOffset.y - scrollView.contentInset.bottom
        let tableHeigt = scrollView.contentSize.height - scrollView.frame.size.height
        
        if(dragHeight < tableHeigt || refreshState == RefreshState.refreshStateLoading){
            return
        }else{
            if(scrollView.isDragging){
                if(dragHeight < tableHeigt + LoadMoreHeaderHeight*0.4){
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
        footerView.frame = CGRect(x: 0, y: scrollView.contentSize.height-LoadMoreHeaderHeight, width: Width, height: LoadMoreHeaderHeight)
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
                self.arrowImage?.transform  = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            })
            break
        case .refreshStatePulling:
            titleLabel?.text = "松开加载"
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.arrowImage?.transform  = CGAffineTransform.identity
            })
            break
        case .refreshStateLoading:
            titleLabel?.text = "正在加载"
            arrowImage?.isHidden = true
            actView?.startAnimating()
            
            //固定顶部
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
                self.scrollView.contentInset.bottom = self.scrollView.contentInset.bottom
            }, completion: { (done) in
                self.delegate?.loadingMore()
            })
        }
    }
    
    func endRefresh(){
        setRrefreshState(.refreshStateNormal)
    }
}

