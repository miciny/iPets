//
//  MCYCoverFlowView.swift
//  iPets
//
//  Created by maocaiyuan on 2017/7/18.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class MCYCoverFlowView: UIScrollView, UIScrollViewDelegate{
    
    private var sideVisibleImageCount: Int!
    private var sideVisibleImageScale: CGFloat!
    private var middleImageScale: CGFloat!
    private var images: NSMutableArray!
    
    private let imageViewWidth = CGFloat(180)
    private let leftRadian = CGFloat(Double.pi/2.5)
    private let rightRadian = CGFloat(-Double.pi/2.5)
    private var gapAmongSideImages: CGFloat = 30.0
    private var gapBetweenMiddleAndSide: CGFloat = 100.0
    private let zPositionGap = CGFloat(10.0)
    
    private var views: NSMutableArray!
    private var currentRenderingImageIndex: Int!

    init(frame: CGRect, andImages: NSMutableArray, sideImageCount: Int, sideImageScale: CGFloat, middleImageScale: CGFloat) {
        super.init(frame: frame)
        
        self.frame = frame
        self.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.9)
        
        self.sideVisibleImageCount = sideImageCount
        self.sideVisibleImageScale = sideImageScale
        self.middleImageScale = middleImageScale
        self.currentRenderingImageIndex = 0
        self.images = NSMutableArray(array: andImages)
        
        self.gapBetweenMiddleAndSide = (imageViewWidth/2) + (imageViewWidth*cos(leftRadian)/2)
        self.gapAmongSideImages = (self.width/2-self.gapBetweenMiddleAndSide)/CGFloat(self.sideVisibleImageCount+1)
        
        self.setUpSelf()
        self.setUpImages()
    }
    
    private func setUpSelf(){
        self.showsHorizontalScrollIndicator = true
        self.delegate = self
        
        var transformPerspective = CATransform3DIdentity
        transformPerspective.m34 = -1.0 / 500.0
        self.layer.sublayerTransform = transformPerspective
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpImages(){
        self.views = NSMutableArray()
        let centerX = self.width/2
        var maxX = CGFloat(0)
        
        for i in 0 ..< self.images.count{
            let image = self.images[i] as! UIImage
            
            let singleView = getSingleImage(image: image, tag: i, scale: (i==0 ? self.middleImageScale : self.sideVisibleImageScale))
//            let x = (i==0) ? centerX : (centerX + gapBetweenMiddleAndSide + gapAmongSideImages * CGFloat(i-1))
            let x = (i==0) ? centerX : (centerX + gapBetweenMiddleAndSide * CGFloat(i))
            singleView.center = CGPoint(x: x, y: self.height/2+imageViewWidth/7)  //+imageViewWidth/7调整高度
            singleView.layer.zPosition = CGFloat(i==0 ? 0 : 1) * -zPositionGap
            
            self.addSubview(singleView)
            views.add(singleView)
            
            maxX = x
        }
        
        self.contentSize = CGSize(width: maxX + self.width/2, height: self.height)
        self.setTrans(offsetX: 0)
    }

    
    
//=============================================delegate=============================

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        self.setTrans(offsetX: offsetX)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        self.setViewX(offsetX: offsetX)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            let offsetX = scrollView.contentOffset.x
            self.setViewX(offsetX: offsetX)
        }
    }
    
    
    
//=============================================计算=============================
    private func setViewX(offsetX: CGFloat){
        let index = lroundf(Float((offsetX)/(gapBetweenMiddleAndSide))) //四舍五入
        self.setViewIndex(index: index)
    }
    
    private func setTrans(offsetX: CGFloat){
        let index = lroundf(Float((offsetX)/(gapBetweenMiddleAndSide))) //四舍五入
        self.currentRenderingImageIndex = index
        let transGap = self.gapBetweenMiddleAndSide
        
        for view in self.views{
            var radian = CGFloat(0)
            var zPosition = CGFloat(0)
            var scale = self.sideVisibleImageScale
            
            let view = view as! UIView
            let reallX = view.centerXX
            let dltX = reallX - offsetX - self.width/2   // transGap -> 0 -> -transGap
            let dltT = abs(dltX)/transGap                   // 1 -> 0 -> 1
            
            if dltX >= self.gapBetweenMiddleAndSide{
                radian = rightRadian
                zPosition = -zPositionGap
            }else if dltX < self.gapBetweenMiddleAndSide && dltX >= 0{
                radian = rightRadian * dltT
                zPosition = -zPositionGap * dltT
                scale = self.middleImageScale - (self.middleImageScale - self.sideVisibleImageScale) * dltT
            }else if dltX > -self.gapBetweenMiddleAndSide && dltX < 0{
                radian = leftRadian * dltT
                zPosition = -zPositionGap * dltT
                scale = self.middleImageScale - (self.middleImageScale - self.sideVisibleImageScale) * dltT
            }else if dltX <= -self.gapBetweenMiddleAndSide{
                radian = leftRadian
                zPosition = -zPositionGap
            }
            
            view.layer.zPosition = zPosition
            let r = CATransform3DMakeRotation(radian, 0, 1, 0)
            view.layer.transform = CATransform3DScale(r, scale!, scale!, 1)
        }
    }
    
    private func setViewIndex(index: Int){
        self.currentRenderingImageIndex = index
        let x = CGFloat(self.currentRenderingImageIndex) * (self.gapBetweenMiddleAndSide)
        let rect = CGRect(x: x, y: 0, width: self.width, height: self.height)
        self.scrollRectToVisible(rect, animated: true)
    }
    
    @objc private func tapedImage(_ sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        guard tag != self.currentRenderingImageIndex else {
            return
        }
        
        self.setViewIndex(index: tag!)
    }
    
//=============================================UI=============================
    private func getSingleImage(image: UIImage, tag: Int, scale: CGFloat) -> UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewWidth*2)
        view.tag = tag
        
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: view.width, height: view.width)
        imageView.center = CGPoint(x: view.width/2, y: view.height/4)
        imageView.image = image
        imageView.tag = tag
        view.addSubview(imageView)
        
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapedImage(_:)))
        imageView.addGestureRecognizer(tap)
        
        // 制作reflection
        let reflectLayer = CALayer()
        reflectLayer.contents = imageView.layer.contents
        reflectLayer.bounds = imageView.layer.bounds
        reflectLayer.position = CGPoint(x: view.width/2, y: view.height*3/4-2)
        reflectLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), 1, 0, 0)
        
        // 给该reflection加个半透明的layer
        let blackLayer = CALayer()
        blackLayer.backgroundColor = UIColor.black.cgColor
        blackLayer.bounds = reflectLayer.bounds
        blackLayer.position = CGPoint(x: blackLayer.bounds.size.width/2, y: blackLayer.bounds.size.height/2)
        blackLayer.opacity = 0.5
        reflectLayer.addSublayer(blackLayer)
        
        // 给该reflection加个mask
        let mask = CAGradientLayer.init(layer: layer)
        mask.bounds = reflectLayer.bounds
        mask.position = CGPoint(x: mask.bounds.size.width/2, y: mask.bounds.size.height/2)
        mask.colors = [UIColor.clear.cgColor,
                       UIColor.white.cgColor]
        mask.startPoint = CGPoint(x: 0.5, y: 0.35)
        mask.endPoint = CGPoint(x: 0.5, y: 1.0)
        reflectLayer.mask = mask
        
        // 作为layer的sublayer
        view.layer.addSublayer(reflectLayer)
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        return view
    }
}
