//
//  SingleChatPicView.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SingleChatPicView: UIView, UIScrollViewDelegate{

    fileprivate var mainView : UIControl!
    fileprivate var countLable : UILabel!
    fileprivate var timeLable: UILabel!
    fileprivate var imageCount: Int!
    fileprivate var imageDate = [Date]()
    fileprivate var view: UIScrollView!
    fileprivate var originFrame: CGRect!
    fileprivate var curentPage: Int!
    fileprivate var index: Int!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpPic(_ image: [UIImage], index: Int, imageDate: [Date], frame: CGRect){
        self.originFrame = frame
        self.index = index
        self.curentPage = index
        
        //为什么用uicontroller加，我也不知道
        self.mainView = UIControl(frame: UIScreen.main.bounds)
        self.mainView.backgroundColor = UIColor.black
        self.mainView.alpha = 1
        UIApplication.shared.keyWindow?.addSubview(self.mainView)
        
        imageCount = image.count
        self.imageDate = imageDate
        
        // scrollView的初始化
        view = UIScrollView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = UIColor.black
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.isPagingEnabled = true
        view.contentSize = CGSize(width: CGFloat(image.count)*Width, height: Height)
        view.scrollRectToVisible(CGRect(x: CGFloat(index) * Width, y: 0, width: Width, height: Height), animated: true)
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
            view.addSubview(imageView)
        }
        
        //显示数控的lable
        countLable = UILabel(frame: CGRect(x: Width-110, y: Height-60, width: 100, height: 30))
        countLable.textAlignment = .center
        countLable.backgroundColor = UIColor.clear
        countLable.textColor = UIColor.white
        countLable.text = String(index+1)+"/"+String(imageCount)
        self.mainView.addSubview(countLable)
        
        //显示时间的lable
        timeLable = UILabel(frame: CGRect(x: 10, y: Height-60, width: 200, height: 30))
        timeLable.textAlignment = .left
        timeLable.backgroundColor = UIColor.clear
        timeLable.textColor = UIColor.white
        let timeStr = DateToToString.dateToStringBySelf(self.imageDate[index], format: "yyyy/MM/dd HH:mm")
        timeLable.text = timeStr
        self.mainView.addSubview(timeLable)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        curentPage = Int(offsetX / Width)
        countLable.text = String(curentPage+1)+"/"+String(imageCount)
        
        let timeStr = DateToToString.dateToStringBySelf(self.imageDate[curentPage], format: "yyyy/MM/dd HH:mm")
        timeLable.text = timeStr
    }
    
    func tapedPic(_ sender: UITapGestureRecognizer){
        self.view.backgroundColor = UIColor.clear
        self.mainView.backgroundColor = UIColor.clear
        
        if curentPage != self.index {
            originFrame = CGRect(x: Width/2-5, y: Height/2-5, width: 10, height: 10)
        }
        var tempFrame = originFrame
        tempFrame?.origin.x = originFrame.origin.x + view.frame.width*CGFloat((sender.view?.tag)!)
        let toFrame = tempFrame
        
        UIView.animate(withDuration: 0.5, animations: {
            self.countLable.isHidden = true
            self.timeLable.isHidden = true
            sender.view?.frame = toFrame!
        }, completion: { (finished) in
            self.mainView.removeFromSuperview()
        }) 
    }

}
