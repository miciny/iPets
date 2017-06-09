//
//  NewsRootViewController.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/30.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class NewsRootViewController: UIViewController, UIScrollViewDelegate, channelClickedDelegate{
    
    fileprivate var mainScroll: UIScrollView! //用于加载视图的scrollView
    fileprivate var channelView: NewsChannelView! //频道
    fileprivate var viewControllers = NSMutableArray() //用于存储所需要显示的视图
    fileprivate var delegate: newsPageChangedDelegate?  //新闻页，新闻滑动，频道也要跟这滑动的代理
    fileprivate var lastPageIndex: Int? //上一次显示的页码
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setUpChannelView()
        setUpScrollView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTitle(){
        automaticallyAdjustsScrollViewInsets = false //手动偏移
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.title = "新闻"
        self.navigationItem.title = "新闻"
    }
    
    //频道
    func setUpChannelView(){
        channelView = NewsChannelView(frame: CGRect(x: 0, y: 64, width: Width, height: 40), target: self)
        channelView.setUpChannelData()
        channelView.setUpScrollView()
        self.delegate = channelView
        self.view.addSubview(channelView)
    }
    
    //channel点击后，新闻也要跟着动
    func channelClicked(_ index: Int) {
        mainScroll.contentOffset = CGPoint(x: self.view.width * CGFloat(index), y: 0)
        
        setUpOneChildViewController(index)
        viewWillDismiss(index)
        lastPageIndex = index
    }
    
    //设置scrollView
    func setUpScrollView(){
        
        let y = channelView.frame.maxY
        mainScroll = UIScrollView()
        mainScroll.frame = CGRect(x: 0, y: y, width: Width, height: Height - 64)
        mainScroll.isPagingEnabled = true // 设置整屏滑动
        mainScroll.showsHorizontalScrollIndicator = false // 隐藏滚动条
        mainScroll.showsVerticalScrollIndicator = false
        mainScroll.delegate = self
        mainScroll?.scrollsToTop = false  //点击系统栏，滑到顶部
        self.view.addSubview(mainScroll)
        
        addChildViewController()
        mainScroll.contentSize = CGSize(width: CGFloat(channelArray.count) * Width, height: 0)
        
        setUpOneChildViewController(0)
        self.delegate?.newsPageChanged(0)
        lastPageIndex = 0
    }
    
    /**  添加子控制器  */
    func addChildViewController(){
        for i in 0 ..< channelArray.count {
            let vc = NewsViewController()
            vc.channel = channelArray[i]
            addChildViewController(vc)
        }
    }
    
    //添加视图到scrollView
    func setUpOneChildViewController(_ i: Int){
        let x = CGFloat(i) * Width  // 显示当前 btn 个数对应的偏移量
        let vc = childViewControllers[i] as! NewsViewController// 得到 btn 对应的控制器
        if let scrollView = vc.mainTabelView{  //点击系统栏，滑到顶部 {
            scrollView.scrollsToTop = true
        }
        guard vc.view.superview == nil else{ return } // 如果视图存在结束函数
        
        vc.view.frame = CGRect(x: x, y: 0, width: Width, height: Height - self.mainScroll.y) // 设置当前视图控制器视图的 frame
        mainScroll.addSubview(vc.view) // 添加当前视图控制器的视图
        vc.mainTabelView?.scrollsToTop = true
    }
    
    //=====================================================================================================
    /**
     MARK: - ScrollView delegate
     **/
    //=====================================================================================================
    
    //这种方式加载试图，滑动不会掉用，需手动掉用
    func viewWillDismiss(_ i: Int){
        
        if i != lastPageIndex {
            let vc = childViewControllers[lastPageIndex!] as! NewsViewController
            vc.viewWillDisappear(true)
            vc.mainTabelView!.scrollsToTop = false  //点击系统栏，滑到顶部
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let i = Int(offset.x/Width)
        setUpOneChildViewController(i)
        
        //新闻页，新闻滑动，频道也要跟这滑动的代理
        self.delegate?.newsPageChanged(i)
        viewWillDismiss(i)
        lastPageIndex = i
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        self.delegate?.newsPageOffsetChanged(offset.x)
    }
    
    //点击tab 刷新页面
    func refreshNewsView() {
        let vc = childViewControllers[lastPageIndex!] as! NewsViewController
        vc.autoRefresh()
    }
}
