//
//  PicViewController.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/4.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class FindPetsPicView: UIView, UIScrollViewDelegate{
    fileprivate var mainView : UIControl!
    fileprivate var pageControl: UIPageControl!
    fileprivate var curentPage = Int()
    fileprivate var view: UIScrollView!
    fileprivate var originFrame: CGRect!
    fileprivate var frames: [CGRect]!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpPic(_ image: [UIImage], index: Int, frame: [CGRect]){
        
        let imageCount = image.count
        self.frames = frame
        originFrame = self.frames[index]
        
        //为什么用uicontroller加，我也不知道
        mainView = UIControl(frame: UIScreen.main.bounds)
        mainView.backgroundColor = UIColor.black
        mainView.alpha = 1
        UIApplication.shared.keyWindow?.addSubview(self.mainView)
        
        //装图片的scrollView
        view = UIScrollView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = UIColor.black
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.delegate = self
        view.contentSize = CGSize(width: CGFloat(image.count)*Width, height: Height)
        view.scrollRectToVisible(CGRect(x: CGFloat(index) * Width, y: 0, width: Width, height: Height), animated: true) //滑动到点击的那张图位置
        mainView.addSubview(view)
        
        for i in 0 ..< imageCount {
            let imageSize = image[i].size
            let imageView = UIImageView()
            
            //等比缩放
            let picW = view.frame.width
            let picH = imageSize.height * Width / imageSize.width
            imageView.frame = CGRect(x: 0 + Width*CGFloat(i) , y: Height/2 - picH/2 , width: picW, height: picH)
            imageView.image = image[i]
            imageView.tag = i
            view.addSubview(imageView)
            
            if i == index {
                //动画
                var tempFrame = originFrame
                tempFrame?.origin.x = originFrame.origin.x + view.frame.width*CGFloat(i)  //调整x坐标
                let fromFrame = tempFrame
                let toFrame = imageView.frame
                imageView.frame = fromFrame!
                
                UIView.animate(withDuration: 0.5, animations: {
                    imageView.frame = toFrame
                })
            }
            
            imageView.isUserInteractionEnabled = true
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapedPic))
            imageView.addGestureRecognizer(tap)
            
        }
        
        initPageControl(imageCount, index: index)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        curentPage = Int(offsetX / Width)
        pageControl.currentPage = curentPage
        originFrame = self.frames[curentPage]
    }

    
    //初始化pageControl
    func initPageControl(_ imageCount: Int, index: Int){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: Height-40, width: Width, height: 20))
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = imageCount
        pageControl.currentPage = index
        self.mainView.addSubview(pageControl)
    }
    
    func tapedPic(_ sender: UITapGestureRecognizer){
//        print(sender.view?.frame)
//        let tempFrame = sender.view?.frame
        
        self.view.backgroundColor = UIColor.clear
        self.mainView.backgroundColor = UIColor.clear
        var tempFrame = originFrame
        tempFrame?.origin.x = originFrame.origin.x + view.frame.width*CGFloat((sender.view?.tag)!)
        let toFrame = tempFrame
        
        UIView.animate(withDuration: 0.5, animations: {
            sender.view?.frame = toFrame!
        }, completion: { (finished) in
            self.mainView.removeFromSuperview()
        }) 
    }

    //隐藏
    func hideView(){
        
//        let animation = CABasicAnimation(keyPath: "transform.scale")
//        animation.fromValue = 1 // 开始时的倍率
//        animation.toValue = 0.1 // 结束时的倍率
//        animation.duration = 0.3
//        animation.fillMode = kCAFillModeForwards  // 保持结束时的状态
//        animation.removedOnCompletion = false
//        self.view.layer.addAnimation(animation, forKey: "")
        
//        delay(0.3) {
//            self.mainView.removeFromSuperview()
//        }
    }
}
