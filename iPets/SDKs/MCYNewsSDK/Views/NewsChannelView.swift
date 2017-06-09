//
//  NewsChannelView.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/30.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

var channelArray = [String]() //频道字符串

//新闻页，新闻滑动，频道也要跟这滑动的代理
protocol newsPageChangedDelegate{
    
    func newsPageChanged(_ index: Int)
    
    //偏移量
    func newsPageOffsetChanged(_ offset: CGFloat)
}

//频道点击，新闻也要跟这滑动的代理
protocol channelClickedDelegate{
    func channelClicked(_ index: Int)
}

class NewsChannelView: UIView, UIScrollViewDelegate, newsPageChangedDelegate{
    
    fileprivate var scrollView: UIScrollView!
    fileprivate var channelBtns: [UIButton]!
    fileprivate var channelLbs: [UILabel]!
    fileprivate var delegate: channelClickedDelegate!  //代理
    fileprivate var animationLine = UIView() //红色的线
    fileprivate var currentPage = Int(0)
    fileprivate var scaleTime = CGFloat(0.15) // 放大倍数
    
    init(frame: CGRect, target: channelClickedDelegate) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.white
        self.delegate = target
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //滑动新闻页，传的index
    func newsPageChanged(_ index: Int) {
        scrollViewBySelf(index)
        forceChangeColorAndFont(index)
        currentPage = index //手动点的
    }
    
    //滑动新闻页，传的偏移量
    func newsPageOffsetChanged(_ offset: CGFloat) {
        
        //当前页面，需要及时计算
        var currentPageTemp = Int((offset)/self.frame.width)
        
        //==================线
        //x坐标的变化,
        let width = channelBtns[currentPageTemp].frame.width
        let selfWidth = self.scrollView.frame.width
        animationLine.center.x = offset * width / selfWidth + (width/2)
        
        //大小的变化
        var offsetX = offset - selfWidth * CGFloat(currentPageTemp)
        let offs = fabs(offsetX) / (selfWidth/2) - 1  //0-2 2-0
        animationLine.frame.size.width = -fabs(offs) * (width/2) + width/2 + 20
        
        //============字体和颜色
        //title颜色变化 
        //向右滑，滑到最后，会突然变的 currentPageTemp > currentPage,此时currentPage＋1
        if currentPageTemp > currentPage{
            currentPageTemp = currentPage
            currentPage += 1
            offsetX = offset-selfWidth*CGFloat(currentPageTemp)
        }else if currentPage - currentPageTemp > 1 { //如果差两页了，应对滑动过快
            currentPage = currentPageTemp + 1
        }
        
        let offc = fabs(offsetX) / (selfWidth) //0-1 1-0
        let toIndex = (currentPageTemp == currentPage ? currentPageTemp+1 : currentPageTemp) //判断左右滑
        color_font_Animation(offc, fromIndex: currentPage, toIndex: toIndex)
    }
    
    //设置数据
    func setUpChannelData(){
        channelArray = [String]()
        channelArray.append("头条")
        channelArray.append("军事")
        channelArray.append("搞笑")
        channelArray.append("娱乐")
        channelArray.append("体育")
        channelArray.append("科技")
    }
    
    //设置scrollView
    func setUpScrollView(){

        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Width, height: 40))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.scrollsToTop = false
        
        let count = channelArray.count
        var offsetX = CGFloat(0) //保存按钮X坐标
        channelBtns = [UIButton]()
        channelLbs = [UILabel]()
        
        for i in 0 ..< count {
            //按钮
            let btnSize = sizeWithText(channelArray[i], font: newsTitleFont, maxSize: CGSize(width: Width, height: 40))
            let channelBtn = UIButton(frame: CGRect(x: offsetX, y: 0, width: btnSize.width+40, height: 40))
            channelBtn.tag = i
            channelBtn.addTarget(self, action: #selector(channelBtnClicked(_:)), for: .touchUpInside)
            channelBtns.append(channelBtn)
            offsetX = channelBtn.frame.maxX
            
            // title
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: channelBtn.frame.width, height: channelBtn.frame.height))
            label.font = newsTitleFont
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.text = channelArray[i]
            channelLbs.append(label)
            
            channelBtn.addSubview(label)
            scrollView.addSubview(channelBtn)
        }

        scrollView.contentSize = CGSize(width: offsetX, height: 0)
        self.addSubview(scrollView)
        setAnimationLine()
    }
    
    //点击按钮后，用代理通知newsroot页显示
    func channelBtnClicked(_ sender: UIButton){
        let index = sender.tag
        
        UIView.animate(withDuration: 0.2, animations: {
            self.animationLine.center.x = self.channelBtns[index].centerXX
            }) { (done) in
                self.currentPage = index
                self.scrollViewBySelf(index)
                self.delegate.channelClicked(index)
                self.forceChangeColorAndFont(index)
        }
    }
    
    //滑动view
    func scrollViewBySelf(_ index: Int){
        
        var first = true //纪录是否是第一个或者最后一个
        var last = true
        
        let offsetX = scrollView.contentOffset.x
        var maxX = channelBtns[index].frame.maxX
        var minX = channelBtns[index].frame.minX
        
        //把未显示的显示出来
        if index < channelBtns.count-1{
            maxX = channelBtns[index+1].frame.maxX
            last = false
        }
        if index > 0 {
            minX = channelBtns[index-1].frame.minX
            first = false
        }
        
        //如果按钮超过了右边界
        if maxX-offsetX > Width{
            scrollView.setContentOffset(CGPoint(x: maxX-self.frame.width-(last==true ? 0 : 15), y: 0), animated: true)
        }
        //如果按钮超过了 左边界
        if minX-offsetX < 0{
            scrollView.setContentOffset(CGPoint(x: minX+(first==true ? 0 : 15), y: 0), animated: true)
        }
    }
    
    //根据index变颜色 和字体,颜色变化，value：0-1的一个数值的
    func color_font_Animation(_ value: CGFloat, fromIndex: Int, toIndex: Int){
        
        guard toIndex < channelArray.count && toIndex >= 0 && value >= 0 && value <= 1 else{
            return
        }
        
        var fromValue = CGFloat()  //1-0
        var toValue = CGFloat()   // 0-1
        
        //向左划的话，是传入的1-0 否则时0-1
        if fromIndex > toIndex { //向左划
            fromValue = value
            toValue = 1 - value
        }else{
            fromValue = (1 - value)
            toValue = value //向右滑到头时，会突然变成0
        }
        
        let fromColor = UIColor(red: fromValue, green: 0, blue: 0, alpha: 1.0)
        let toColor = UIColor(red: toValue, green: 0, blue: 0, alpha: 1.0)
        
        channelLbs[fromIndex].textColor = fromColor
        channelLbs[toIndex].textColor = toColor
        
        // 大小缩放比例
        let fromTransformScale = 1 + (fromValue * scaleTime)
        let toTransformScale = 1 + (toValue * scaleTime)
        channelLbs[fromIndex].transform = CGAffineTransform(scaleX: fromTransformScale, y: fromTransformScale)
        channelLbs[toIndex].transform = CGAffineTransform(scaleX: toTransformScale, y: toTransformScale)
        
    }
    
    //滑动太快，可能出问题，滑完之后，强制改状态
    func forceChangeColorAndFont(_ index: Int){
        
        for j in 0 ..< channelBtns.count {
            if j == index {
                channelLbs[j].textColor = UIColor.red
                channelLbs[j].transform = CGAffineTransform(scaleX: 1+scaleTime, y: 1+scaleTime)
            }else{
                channelLbs[j].textColor = UIColor.black
                channelLbs[j].transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    //设置animationLine
    func setAnimationLine(){
        animationLine.frame = CGRect(x: channelBtns[0].frame.width/2-10, y: scrollView.frame.maxY - 2,
                                     width: 20, height: 2)
        animationLine.backgroundColor = UIColor.red
        scrollView.addSubview(animationLine)
    }

}
