//
//  ShowSinglePicView.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/22.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Kingfisher
import Social

protocol ShowSinglePicViewDelegate {
    func toShareImage(image: UIImage)
}

class ShowSinglePicView: UIView, UIScrollViewDelegate{
    fileprivate var mainView : UIControl!
    fileprivate var imageView: UIImageView!
    fileprivate var scroll: UIScrollView! //进行缩放的
    
    var delegate: ShowSinglePicViewDelegate?
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpPic(_ imageURL: String, width: CGFloat, height: CGFloat){
        //为什么用uicontroller加，我也不知道
        self.mainView = UIControl(frame: UIScreen.main.bounds)
        self.mainView.backgroundColor = UIColor.black
        self.mainView.alpha = 1
        UIApplication.shared.keyWindow?.addSubview(self.mainView)
        
        //初始化image
        self.imageView = UIImageView()
        scroll = UIScrollView()
        scroll.frame = CGRect(x: 0, y: 0, width: Width, height: Height)
        scroll.delegate = self
        scroll.maximumZoomScale = 2
        scroll.minimumZoomScale = 1
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.addSubview(imageView)
        self.mainView.addSubview(scroll)
        
        //等比缩放
        let picW = Width
        let picH = height * Width / width
        scroll.contentSize = CGSize(width: picW, height: picH)
        
        //动画
        let fromFrame = CGRect(x: Width/2-100, y: Height/2-100, width: 200, height: 200)
        let toFrame = CGRect(origin: CGPoint(x: 0, y: Height/2-picH/2), size: CGSize(width: picW, height: picH) )
        imageView.frame = fromFrame
        
        //加载图片
        NetFuncs.loadPic(imageView: imageView, picUrl: imageURL) { (image) in
            logger.info(image ?? "no image found")
            self.addEvent(image)
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView.frame = toFrame
                self.imageView.alpha = 1
            })
        }
    }
    
    //指定缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    //中心点缩放
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let view = scrollView.subviews.first
        if ((view?.frame.height)! <= Height) {
            view!.center.y = Height/2
        }
    }
    
    //添加手势
    func addEvent(_ image: UIImage?){
        self.imageView.isUserInteractionEnabled = true
        
        if image != nil {
            //长按手势
            let longpressGesutre = UILongPressGestureRecognizer(target: self, action: #selector(picMore))
            longpressGesutre.minimumPressDuration = 1 //长按时间为1秒
            longpressGesutre.allowableMovement = 15 //允许15秒运动
            longpressGesutre.numberOfTouchesRequired = 1 //所需触摸1次
            self.imageView.addGestureRecognizer(longpressGesutre)
        }
        
        //单击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapedPic))
        self.imageView.addGestureRecognizer(tap)
    }
    
    //点击图片，消失
    @objc func tapedPic(){
        self.backgroundColor = UIColor.clear
        self.mainView.backgroundColor = UIColor.clear
        //动画
        UIView.animate(withDuration: 0.5, animations: {
            self.scroll.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            self.scroll.alpha = 0.1
        }, completion: { (finished) in
            self.mainView.removeFromSuperview()
        }) 
    }
    
    //弹出添加的actionView
    fileprivate var bottomMenu = MyBottomMenuView()
    @objc func picMore(){
        if bottomMenu.isShowingMenu == false {
            bottomMenu = MyBottomMenuView()
            let addArray = ["分享","保存"]
            bottomMenu.showBottomMenu("", cancel: "取消", object: addArray as NSArray, eventFlag: 0 , target: self)
        }
    }
    
    //保存图片回调的函数
    @objc func image(_ image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject){
        
        if didFinishSavingWithError != nil{
            ToastView().showToast("保存出错！")
            return
        }
        ToastView().showToast("保存成功！")
    }
    
}

//actionView选择的协议
extension ShowSinglePicView: bottomMenuViewDelegate{
    func buttonClicked(_ tag: Int, eventFlag: Int) {
        switch eventFlag{
        case 0:
            switch tag{
            case 0:
                self.delegate?.toShareImage(image: imageView.image!)
                self.tapedPic()
            case 1:
                //保存图片到本地相册
                UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self,
                                               #selector(ShowSinglePicView.image), nil)
            default:
                break
            }
        default:
            break
        }
    }
}

