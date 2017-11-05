//
//  NewsHeaderView.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/29.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

//头图代理
protocol headerViewDelegate{
    func newsClicked(_ data: NewsHeaderDataModule)
}

class NewsHeaderView: UIView, UIScrollViewDelegate{
    
    var headerData: [NewsHeaderDataModule]?
    fileprivate var delegate: headerViewDelegate?
    fileprivate var scrollView: UIScrollView!
    fileprivate var imageViews: [UIImageView]!
    fileprivate var pageControl: UIPageControl!
    fileprivate var currentPage: Int?
    fileprivate var headerDataArray: NSMutableArray!
    
    fileprivate var titleLb: UILabel?
    fileprivate var labelView: UIView?
    
    init(frame: CGRect, target: headerViewDelegate) {
        super.init(frame: frame)
        self.delegate = target
        self.frame = frame
        self.backgroundColor = UIColor.cellPicBackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置view
    func setUpView(){
        progressData()
        
        let count = headerDataArray.count
        
        //滚动
        scrollView = UIScrollView(frame: self.frame)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: CGFloat(count)*self.frame.width, height: 0)
        scrollView.scrollsToTop = false
        
        //数量控制器
        let sizeTime: CGFloat = 0.7
        pageControl = UIPageControl()
        pageControl.size(forNumberOfPages: count)
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.frame.size = (pageControl.size(forNumberOfPages: count-2))
        pageControl.frame.origin = CGPoint(x: self.width-pageControl.width*sizeTime-20, y: self.height-pageControl.height*sizeTime-5)
        pageControl.numberOfPages = count-2
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.transform = CGAffineTransform(scaleX: sizeTime, y: sizeTime) //缩小
        
        //title
        let titleSize = sizeWithText("测试", font: headerTitleFont, maxSize: CGSize(width: Width, height: Height)) //主要是获取高度
        titleLb = UILabel(frame: CGRect(x: 10, y: self.height-5-titleSize.height, width: titleSize.width, height: titleSize.height))
        titleLb!.textColor = UIColor.white
        titleLb!.font = headerTitleFont
        titleLb!.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        progressPic() //图片
        
        self.addSubview(scrollView)
        self.addSubview(pageControl)
        self.addSubview(titleLb!)
        
        self.currentPage = 1
        setTitle()
    }
    
    //刷新时，重新加载数据
    func refreshData(){
        //清除原view
        for subView in self.subviews{
            subView.removeFromSuperview()
        }
        setUpView()
    }
    
    //渐变色的蒙层
    func setBackView(_ view: UIView){
        //渐变色
        let topColor = UIColor.clear
        let buttomColor = UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 0.8)
        //将颜色和颜色的位置定义在数组内
        let gradientColors: [CGColor] = [topColor.cgColor, buttomColor.cgColor]
        let gradientLocations: [CGFloat] = [0.0, 1.0]
        //创建CAGradientLayer实例并设置参数
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        //设置其frame以及插入view的layer
        gradientLayer.frame = CGRect(x: 0, y: view.frame.height*3/4, width: view.frame.width, height: view.frame.height/4)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //处理数据，为了轮滑
    func progressData(){
        //处理下数据
        headerDataArray = NSMutableArray()
        for data in headerData! {
            if data.category != newsType.unkown {
                headerDataArray.add(data)
            }
        }
        //把最后一个加到第一个，把第一个加到最后一个
        self.headerDataArray.insert((self.headerDataArray.lastObject)!, at: 0)
        self.headerDataArray.add(self.headerDataArray[1])
    }
    
    //处理里面的图片
    func progressPic(){
        let count = headerDataArray.count
        //图片
        imageViews = [UIImageView]()
        for i in 0 ..< count {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(i)*self.width, y: 0, width: self.width, height: self.height))
            
            imageView.isUserInteractionEnabled = true
            imageView.tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickedNews))
            imageView.addGestureRecognizer(tap)
            
            scrollView.addSubview(imageView)
            setBackView(imageView)
            imageViews.append(imageView)
        }
    }
    
    //点击事件
    @objc func clickedNews(){
        let data = headerDataArray[currentPage!] as! NewsHeaderDataModule
        self.delegate?.newsClicked(data)
    }
    
    //设置图片数据等
    func setData(){
        let count = headerDataArray.count
        for i in 0 ..< count {
            let data = headerDataArray[i] as! NewsHeaderDataModule
            NetFuncs.showPic(imageView: imageViews[i], picUrl: data.kpic!)
        }
        self.scrollView.contentOffset = CGPoint(x: self.frame.width, y: 0)
    }
    
    //
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        currentPage = Int(offsetX / self.frame.width)
        pageControl.currentPage = currentPage!-1 //-1
        
        let count = headerDataArray.count
        if currentPage == 0 {
            self.scrollView.contentOffset = CGPoint(x: self.frame.width*CGFloat(count-2), y: 0)
            self.pageControl.currentPage = count-1
        }else if (currentPage == count-1){
            self.scrollView.contentOffset = CGPoint(x: self.frame.width, y: 0)
            self.pageControl.currentPage = 0
        }
        setTitle()
    }
    
    //设置title
    func setTitle(){
        let data = headerDataArray[currentPage!] as! NewsHeaderDataModule
        var titleMinY = CGFloat(5)
        if let title = data.title{
            let titleSize = sizeWithText(title, font: headerTitleFont, maxSize: CGSize(width: pageControl.x-10, height: Height))
            titleLb?.frame.size.width = titleSize.width
            titleLb?.text = title
            
            titleMinY = (titleLb?.frame.minY)!
        }
        
        if labelView != nil{
            labelView?.removeFromSuperview()
        }
        //标签
        if data.category == newsType.hdpic {
            labelView = UILabel.headerLabelView("\(data.pics_total!)图")
            labelView!.frame.origin = CGPoint(x: 10, y: titleMinY-5-labelView!.height)
            self.addSubview(labelView!)
        }else if data.category == newsType.plan {
            labelView = UILabel.headerLabelView("策划")
            labelView!.frame.origin = CGPoint(x: 10, y: titleMinY-5-labelView!.height)
            self.addSubview(labelView!)
        }else if data.category == newsType.subject {
            labelView = UILabel.headerLabelView("专题")
            labelView!.frame.origin = CGPoint(x: 10, y: titleMinY-5-labelView!.height)
            self.addSubview(labelView!)
        }
    }
}
