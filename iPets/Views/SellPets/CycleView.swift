//
//  CycleView.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/18.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class HeaderCycleView: UIView, UIScrollViewDelegate{
    //MARK:- private 属性
    
    private var viewWidth: CGFloat{
        return self.bounds.width
    }
    private var viewHeight: CGFloat{
        return self.bounds.height
    }
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var timer: NSTimer?
    private var centerImageView: UIImageView! //中间，如果只有一张图。。。
    private var leftImageView: UIImageView!
    private var rightImageView: UIImageView!
    private var isAutoScrolling: Bool = false
    
    var time = NSTimeInterval(3)
    
    //MARK:- 公共属性<##>
    var currentIndex = 0{
        didSet{
            
            if currentIndex < 0{//判断currentIndex应该为最后一张
                currentIndex = delegate!.numbersOfPages() - 1
            }else if currentIndex > delegate!.numbersOfPages() - 1{//判断currentIndex是否应该是第一张
                currentIndex = 0
            }
            reloadImage()
            
        }
    }
    
    //监听deleagte didSet方法
    var delegate: MCYAutoScrollViewDelegate?{
        didSet{
            if delegate!.numbersOfPages() == 1{
                scrollView.scrollEnabled = false //如果只有一张图，就不让滑动
            }
            pageControl.numberOfPages = delegate!.numbersOfPages()
            reloadImage()
        }
    }
    
    //是否开启自动滚动
    var autoScroll: Bool = false{
        didSet{
            if autoScroll && isAutoScrolling == false{
                addTimer()
            }else {
                removeTimer()
            }
        }
    }
    
    //自动滑动的定时器
    func addTimer(){
        timer = NSTimer(timeInterval: time, target: self, selector: #selector(HeaderCycleView.nextPage), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        self.isAutoScrolling = true
    }
    
    func removeTimer(){
        timer?.invalidate()
        timer = nil
        self.isAutoScrolling = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initScrollView()
        self.initPageControl()
        
    }
    
    //MARK: - 初始化界面
    
    //初始化pageControl
    func initPageControl(){
        pageControl = UIPageControl(frame: CGRectMake(0, viewHeight-40, viewWidth, 20))
        pageControl.currentPageIndicatorTintColor = UIColor.redColor()
        pageControl.pageIndicatorTintColor = UIColor.greenColor()
        pageControl.hidesForSinglePage = true
        addSubview(pageControl)
    }
    
    //初始化UIScrollView
    func initScrollView(){
        scrollView = UIScrollView(frame: CGRectMake(0, 0, viewWidth, viewHeight))
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        for index in 0...2{
            switch index{
            case 0:
                leftImageView = createImageView(index)
            case 1:
                centerImageView = createImageView(index)
            case 2:
                rightImageView = createImageView(index)
            default:
                break
            }
        }
        
        scrollView.addSubview(leftImageView)
        scrollView.addSubview(centerImageView)
        scrollView.addSubview(rightImageView)
        
        scrollView.contentSize = CGSizeMake(3*viewWidth, 0)
        addSubview(scrollView)
    }
    
    //创建imageView 并添加点击手势
    func createImageView(index: Int) -> UIImageView{
        let imageView = UIImageView(frame: CGRectMake(CGFloat(index)*viewWidth, 0, viewWidth, viewHeight))
        imageView.autoresizingMask = .None
        imageView.layer.masksToBounds = true
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HeaderCycleView.handleTap(_:))))
        return imageView
    }
    
    //处理图片点击事件
    func handleTap(tap: UITapGestureRecognizer){
        if let _ = self.delegate{
            if delegate!.respondsToSelector(#selector(MCYAutoScrollViewDelegate.didSelectedIndex(_:))){
                delegate!.didSelectedIndex!(currentIndex)
            }
        }
    }
    
    //根据index设置相关图片
    func setImage(leftImageIndex: Int=9, centerImageIndex: Int=0, rightImageIndex: Int=1){
        
        //从代理中获取每个图片的图片名称
        let leftImageName = self.delegate!.imageNameOfIndex(leftImageIndex)
        let centerImageName = self.delegate!.imageNameOfIndex(centerImageIndex)
        let rightImageName = self.delegate!.imageNameOfIndex(rightImageIndex)
        
        //此处使用的是本地图片 也可以使用网络图片
        if let leftImage = UIImage(named: leftImageName){
            leftImageView.image = leftImage
        }
        if let centerImage = UIImage(named: centerImageName){
            centerImageView.image = centerImage
        }
        if let rightImage = UIImage(named: rightImageName){
            rightImageView.image = rightImage
        }
        
    }
    
    func reloadImage(){
        var leftImageIndex = 0,rightImageIndex = 0
        
        if currentIndex == 0{
            leftImageIndex = self.delegate!.numbersOfPages() - 1
            //解决如果只有一张图时，index超范围
            if(self.delegate!.numbersOfPages() == 1){
                rightImageIndex = 0
            }else{
                rightImageIndex = 1
            }
            
        }else if currentIndex == self.delegate!.numbersOfPages() - 1{
            leftImageIndex = self.delegate!.numbersOfPages() - 2
            rightImageIndex = 0
        }else{
            leftImageIndex = currentIndex - 1
            rightImageIndex = currentIndex + 1
        }
        
        setImage(leftImageIndex, centerImageIndex: currentIndex, rightImageIndex: rightImageIndex)
        scrollView.setContentOffset(CGPointMake(viewWidth, 0), animated: false)
        pageControl.currentPage = currentIndex
    }
    
    func nextPage(){
        UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
            self.scrollView.setContentOffset(CGPointMake(2*self.viewWidth, 0), animated: false)
            }) { [unowned self] (isFinish) -> Void in
                self.currentIndex += 1
        }
    }
    
    //MARK:- UIScrollView Delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //判断 是否允许自动滚动,允许则重新添加定时器,继续滚动
        if autoScroll{
            addTimer()
        }
    }
    
    //如果结束后再判断，会有问题，滑动过快就会出问题
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offsetX: CGFloat = scrollView.contentOffset.x
        var tempIndex = currentIndex
        if offsetX < viewWidth*0.7{ //判断是否向左滑
            tempIndex -= 1
        }else if offsetX > viewWidth*1.3{ //判断是否是向右滑动
            tempIndex += 1
        }
        if currentIndex == tempIndex {
            return
        }
        currentIndex = tempIndex
        //重新配置imageView的image
        //执行代理currentIndexDidChange
        if let _ = self.delegate{
            if delegate!.respondsToSelector(#selector(MCYAutoScrollViewDelegate.currentIndexDidChange(_:))){
                delegate!.currentIndexDidChange!(currentIndex)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
