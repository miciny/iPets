//
//  SingleChatPicView.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class PicsBrowserView: UIControl, UIScrollViewDelegate{

    //fileprivate var controlView: UIControl!
    fileprivate var mainScrollview: UIScrollView!
    fileprivate var showPics = [UIImageView]()
    fileprivate var scrolls = [UIScrollView]()
    
    fileprivate var originFrame: CGRect!
    fileprivate var curentPage: Int!
    fileprivate var index: Int!
    fileprivate var imageCount: Int!
    
    fileprivate var pageControl: UIPageControl?
    fileprivate var frames: [CGRect]?
    
    fileprivate var countLable: UILabel?
    fileprivate var timeLable: UILabel?
    fileprivate var imageDate: [Date]?
    fileprivate var images: [UIImage]?
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //带所有frame的
    func setUpAllFramePicBrowser(_ image: [UIImage], index: Int, frame: [CGRect]){
        
        self.frames = frame
        self.originFrame = self.frames![index]
        self.index = index
        self.curentPage = index
        showPics.removeAll()
        scrolls.removeAll()
        imageCount = image.count
        self.images = image
        
        // scrollView的初始化
        self.setUpMainScroll()
        mainScrollview.contentSize = CGSize(width: CGFloat(imageCount!)*Width, height: Height)
        mainScrollview.scrollRectToVisible(CGRect(x: CGFloat(index) * Width, y: 0, width: Width, height: Height), animated: true)
        self.addSubview(mainScrollview)
        
        self.setupImage()
        self.initPageControl(imageCount, index: index)
    }
    
    
    //一个frame的
    func setUpSingleFramePicBrowser(_ image: [UIImage], index: Int, imageDate: [Date], frame: CGRect){
        self.originFrame = frame
        self.index = index
        self.curentPage = index
        showPics.removeAll()
        scrolls.removeAll()
        imageCount = image.count
        self.imageDate = imageDate
        self.images = image
        
        // scrollView的初始化
        self.setUpMainScroll()
        mainScrollview.contentSize = CGSize(width: CGFloat(imageCount)*Width, height: Height)
        mainScrollview.scrollRectToVisible(CGRect(x: CGFloat(index) * Width, y: 0, width: Width, height: Height), animated: true)
        self.addSubview(mainScrollview)
        
        self.setupImage()
        self.setupLabel()
    }
    
    func setupImage(){
        //加载图片
        for i in 0 ..< imageCount {
            let imageSize = self.images![i].size
            let imageView = UIImageView()
            //等比缩放
            let picW = Width
            let picH = imageSize.height * Width / imageSize.width
            imageView.frame = CGRect(x: 0 , y: Height/2 - picH/2 , width: picW, height: picH)
            imageView.image = self.images![i]
            imageView.tag = i
            
            self.addGesture(imageView: imageView)
            
            //进行缩放的
            let scroll = self.setupZoomScroll()
            scroll.frame = CGRect(x: CGFloat(i)*Width, y: 0, width: Width, height: Height)
            scroll.tag = i
            scroll.addSubview(imageView)
            mainScrollview.addSubview(scroll)
            self.showPics.append(imageView)
            
            if i == index {
                //动画
                var tempFrame = originFrame
                tempFrame?.origin.x = originFrame.origin.x  //调整x坐标
                let fromFrame = tempFrame
                let toFrame = imageView.frame
                imageView.frame = fromFrame!
                
                UIView.animate(withDuration: 0.5, animations: {
                    imageView.frame = toFrame
                })
            }
        }
    }
    
    //添加手势
    func addGesture(imageView: UIImageView){
        
        //单机事件
        imageView.isUserInteractionEnabled = true
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapedPic))
        imageView.addGestureRecognizer(tap)
        
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target: self, action: #selector(picMore))
        longpressGesutre.minimumPressDuration = 0.6 //长按时间为1秒
        longpressGesutre.allowableMovement = 15 //允许15秒运动
        longpressGesutre.numberOfTouchesRequired = 1 //所需触摸1次
        imageView.addGestureRecognizer(longpressGesutre)
    }
    
    //初始化pageControl
    func initPageControl(_ imageCount: Int, index: Int){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: Height-40, width: Width, height: 20))
        pageControl!.currentPageIndicatorTintColor = UIColor.white
        pageControl!.pageIndicatorTintColor = UIColor.gray
        pageControl!.hidesForSinglePage = true
        pageControl!.numberOfPages = imageCount
        pageControl!.currentPage = index
        self.addSubview(pageControl!)
    }
    
    func setupLabel(){
        
        //显示数控的lable
        countLable = UILabel(frame: CGRect(x: Width-110, y: Height-60, width: 100, height: 30))
        countLable!.textAlignment = .center
        countLable!.backgroundColor = UIColor.clear
        countLable!.textColor = UIColor.white
        countLable!.text = String(index+1)+"/"+String(imageCount)
        self.addSubview(countLable!)
        
        //显示时间的lable
        timeLable = UILabel(frame: CGRect(x: 10, y: Height-60, width: 200, height: 30))
        timeLable!.textAlignment = .left
        timeLable!.backgroundColor = UIColor.clear
        timeLable!.textColor = UIColor.white
        let timeStr = DateToToString.dateToStringBySelf(self.imageDate![index], format: "yyyy/MM/dd HH:mm")
        timeLable!.text = timeStr
        self.addSubview(timeLable!)
    }
    
    func setupZoomScroll() -> UIScrollView{
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.maximumZoomScale = 2
        scroll.minimumZoomScale = 1
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scrolls.append(scroll)
        return scroll
    }
    
    func setUpMainScroll(){
        
        //为什么用uicontroller加，我也不知道
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black
        self.alpha = 1
        UIApplication.shared.keyWindow?.addSubview(self)
        
        mainScrollview = UIScrollView()
        mainScrollview.frame = UIScreen.main.bounds
        mainScrollview.backgroundColor = UIColor.black
        mainScrollview.showsVerticalScrollIndicator = false
        mainScrollview.showsHorizontalScrollIndicator = false
        mainScrollview.tag = 100
        mainScrollview.delegate = self
        mainScrollview.isPagingEnabled = true
    }
    
    //指定缩放的视图
    //缩放的view
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.tag != 100 {
            return self.showPics[scrollView.tag]
        }
        return nil
    }
    
    //中心点缩放
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let view = scrollView.subviews.first
        if ((view?.frame.height)! <= Height) {
            view!.center.y = Height/2
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        curentPage = Int(offsetX / Width)
        
        //时间label
        countLable?.text = String(curentPage+1)+"/"+String(imageCount)
        if let imageData = self.imageDate{
            let timeStr = DateToToString.dateToStringBySelf(imageData[curentPage], format: "yyyy/MM/dd HH:mm")
            timeLable?.text = timeStr
        }
        
        //控制器
        pageControl?.currentPage = curentPage
        if let frame = frames{
            originFrame = frame[curentPage]
        }
        
        if scrollView.tag == 100 {
            //恢复缩放
            for sView in scrollView.subviews{
                // 在根据⼦子类的对象类型进⾏行判断
                if sView.isKind(of: UIScrollView.classForCoder()) && sView.tag != curentPage{
                    // 把视图的尺⼨寸恢复到原有尺⼨寸
                    let view = sView as! UIScrollView
                    view.zoomScale = 1.0
                }
            }
        }
    }
    
    
    //长按图片
    fileprivate var bottomMenu = MyBottomMenuView()
    func picMore(){
        if bottomMenu.isShowingMenu == false {
            bottomMenu = MyBottomMenuView()
            let addArray = ["分享","保存"]
            bottomMenu.showBottomMenu("", cancel: "取消", object: addArray as NSArray, eventFlag: 0 , target: self)
        }
    }
    
    //点击图片
    func tapedPic(_ sender: UITapGestureRecognizer){
        self.mainScrollview.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        self.pageControl?.isHidden = true
        
        
        //暂时用 pageControl 区分
        if pageControl == nil && curentPage != self.index {
            originFrame = CGRect(x: Width/2-5, y: Height/2-5, width: 10, height: 10)
        }
        
        var tempFrame = originFrame
        tempFrame?.origin.x = originFrame.origin.x
        let toFrame = tempFrame
        
        UIView.animate(withDuration: 0.5, animations: {
            self.countLable?.isHidden = true
            self.timeLable?.isHidden = true
            
            self.scrolls[self.curentPage].setZoomScale(1, animated: true)
            self.showPics[self.curentPage].frame = toFrame!
            
        }, completion: { (finished) in
            self.images = nil
            
            for sub in self.subviews{
                sub.removeFromSuperview()
            }
            self.removeFromSuperview()
        }) 
    }
    
    //保存图片回调的函数
    func image(_ image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject){
        
        if didFinishSavingWithError != nil{
            ToastView().showToast("保存出错！")
            return
        }
        ToastView().showToast("保存成功！")
    }

}

//actionView选择的协议
extension PicsBrowserView: bottomMenuViewDelegate{
    func buttonClicked(_ tag: Int, eventFlag: Int) {
        switch eventFlag{
        case 0:
            switch tag{
            case 0:
                ToastView().showToast("未实现")
            case 1:
                //保存图片到本地相册
                UIImageWriteToSavedPhotosAlbum(self.showPics[curentPage].image!, self,
                                               #selector(self.image), nil)
            default:
                break
            }
        default:
            break
        }
    }
}
