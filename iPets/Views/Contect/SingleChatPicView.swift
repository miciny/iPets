//
//  SingleChatPicView.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SingleChatPicView: UIView, UIScrollViewDelegate{

    private var mainView : UIControl!
    private var countLable : UILabel!
    private var timeLable: UILabel!
    private var imageCount: Int!
    private var imageDate = [NSDate]()
    private var view: UIScrollView!
    private var originFrame: CGRect!
    private var curentPage: Int!
    private var index: Int!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpPic(image: [UIImage], index: Int, imageDate: [NSDate], frame: CGRect){
        self.originFrame = frame
        self.index = index
        self.curentPage = index
        
        //为什么用uicontroller加，我也不知道
        self.mainView = UIControl(frame: UIScreen.mainScreen().bounds)
        self.mainView.backgroundColor = UIColor.blackColor()
        self.mainView.alpha = 1
        UIApplication.sharedApplication().keyWindow?.addSubview(self.mainView)
        
        imageCount = image.count
        self.imageDate = imageDate
        
        // scrollView的初始化
        view = UIScrollView()
        view.frame = UIScreen.mainScreen().bounds
        view.backgroundColor = UIColor.blackColor()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.pagingEnabled = true
        view.contentSize = CGSize(width: CGFloat(image.count)*Width, height: Height)
        view.scrollRectToVisible(CGRectMake(CGFloat(index) * Width, 0, Width, Height), animated: true)
        mainView.addSubview(view)
        
        //加载图片
        for i in 0 ..< imageCount {
            let imageSize = image[i].size
            let imageView = UIImageView()
            //等比缩放
            let picW = Width
            let picH = imageSize.height * Width / imageSize.width
            imageView.frame = CGRect(x: 0 + Width*CGFloat(i) , y: Height/2 - picH/2 , width: picW, height: picH)
            imageView.image = image[i]
            imageView.tag = i
            
            if i == index {
                //动画
                var tempFrame = originFrame
                tempFrame.origin.x = originFrame.origin.x + view.frame.width*CGFloat(i)  //调整x坐标
                let fromFrame = tempFrame
                let toFrame = imageView.frame
                imageView.frame = fromFrame
                
                UIView.animateWithDuration(0.5, animations: {
                    imageView.frame = toFrame
                })
            }
            
            imageView.userInteractionEnabled = true
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapedPic))
            imageView.addGestureRecognizer(tap)
            view.addSubview(imageView)
        }
        
        //显示数控的lable
        countLable = UILabel(frame: CGRect(x: Width-110, y: Height-60, width: 100, height: 30))
        countLable.textAlignment = .Center
        countLable.backgroundColor = UIColor.clearColor()
        countLable.textColor = UIColor.whiteColor()
        countLable.text = "\(index+1)/\(imageCount)"
        self.mainView.addSubview(countLable)
        
        //显示时间的lable
        timeLable = UILabel(frame: CGRect(x: 10, y: Height-60, width: 200, height: 30))
        timeLable.textAlignment = .Left
        timeLable.backgroundColor = UIColor.clearColor()
        timeLable.textColor = UIColor.whiteColor()
        let timeStr = DateToToString.dateToStringBySelf(self.imageDate[index], format: "yyyy/MM/dd HH:mm")
        timeLable.text = timeStr
        self.mainView.addSubview(timeLable)
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        curentPage = Int(offsetX / Width)
        countLable.text = "\(curentPage+1)/\(imageCount)"
        
        let timeStr = DateToToString.dateToStringBySelf(self.imageDate[curentPage], format: "yyyy/MM/dd HH:mm")
        timeLable.text = timeStr
    }
    
    func tapedPic(sender: UITapGestureRecognizer){
        self.view.backgroundColor = UIColor.clearColor()
        self.mainView.backgroundColor = UIColor.clearColor()
        
        if curentPage != self.index {
            originFrame = CGRect(x: Width/2-5, y: Height/2-5, width: 10, height: 10)
        }
        var tempFrame = originFrame
        tempFrame.origin.x = originFrame.origin.x + view.frame.width*CGFloat((sender.view?.tag)!)
        let toFrame = tempFrame
        
        UIView.animateWithDuration(0.5, animations: {
            sender.view?.frame = toFrame
        }) { (finished) in
            self.mainView.removeFromSuperview()
        }
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
//        
//        delay(0.3) {
//            self.mainView.removeFromSuperview()
//        }
    }

}
