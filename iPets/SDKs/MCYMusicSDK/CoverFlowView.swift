//
//  CoverFlowView.swift
//  iPets
//
//  Created by maocaiyuan on 2017/7/12.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class CoverFlowView: UIView {
    
    private var sideVisibleImageCount: Int!
    private var sideVisibleImageScale: CGFloat!
    private var middleImageScale: CGFloat!
    private var images: NSMutableArray!
    
    private var imageLayers: NSMutableArray!
    private var templateLayers: NSMutableArray!
    private var currentRenderingImageIndex: Int!
    private var currentImagesIndex: Int!
    
    private var DISTNACE_TO_MAKE_MOVE_FOR_SWIPE: CGFloat = 60
    private var imageViewWidth = CGFloat(180)
    
    private let leftRadian = CGFloat(Double.pi/2.5)
    private let rightRadian = CGFloat(-Double.pi/2.5)
    
    private var gapAmongSideImages: CGFloat = 30.0
    private var gapBetweenMiddleAndSide: CGFloat = 100.0
    private let zPositionGap = CGFloat(10)
    
    init(frame: CGRect, andImages: NSMutableArray, sideImageCount: Int, sideImageScale: CGFloat, middleImageScale: CGFloat) {
        super.init(frame: frame)
        
        self.frame = frame
        self.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.9)
        
        self.sideVisibleImageCount = sideImageCount
        self.sideVisibleImageScale = sideImageScale
        self.middleImageScale = middleImageScale
        
        self.imageViewWidth = Width/2
        self.currentRenderingImageIndex = 0
        self.currentImagesIndex = 0
        self.images = NSMutableArray(array: andImages)
        self.imageLayers = NSMutableArray(capacity: self.sideVisibleImageCount * 2 + 1)
        self.templateLayers = NSMutableArray(capacity: (self.sideVisibleImageCount+1) * 2 + 1)
        
        self.gapBetweenMiddleAndSide = (imageViewWidth*middleImageScale/2-20) + (imageViewWidth*cos(leftRadian)/2)
        self.gapAmongSideImages = (self.width/2-self.gapBetweenMiddleAndSide)/CGFloat(self.sideVisibleImageCount+1)
        
        self.setUpGesture()
        self.setupTemplateLayers()
        self.setUpImages()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpGesture(){
        let gestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.handleGesture(_:)))
        self.addGestureRecognizer(gestureRecognizer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapedImage(_:)))
        self.addGestureRecognizer(tap)
        
        var transformPerspective = CATransform3DIdentity
        transformPerspective.m34 = -1.0 / 500.0
        self.layer.sublayerTransform = transformPerspective
    }
    
    
    @objc private func handleGesture(_ recognizer: UIPanGestureRecognizer){
        
        if recognizer.state == UIGestureRecognizerState.changed{
            //get offset
            let offset = recognizer.translation(in: recognizer.view)
            let isSwipingToLeftDirection = (offset.x > 0) ? false : true
            
            if abs(offset.x) >= DISTNACE_TO_MAKE_MOVE_FOR_SWIPE {
                self.move(isSwipingToLeftDirection, xScale: 1, isSwiped: true)
                self.moveOneStep(isSwipingToLeftDirection)
                recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            }else{
                self.move(isSwipingToLeftDirection, xScale: (offset.x)/DISTNACE_TO_MAKE_MOVE_FOR_SWIPE, isSwiped: true)
            }
        }else if recognizer.state == UIGestureRecognizerState.ended{
            
            let offset = recognizer.translation(in: recognizer.view)
            let isSwipingToLeftDirection = (offset.x > 0) ? false : true
            
            if abs(offset.x) > DISTNACE_TO_MAKE_MOVE_FOR_SWIPE/2{
                self.move(isSwipingToLeftDirection, xScale: 1, isSwiped: true)
                self.moveOneStep(isSwipingToLeftDirection)
            }else{
                self.move(!isSwipingToLeftDirection, xScale: 1, isSwiped: false)
            }
        }
        
    }
    
    //xScale 比例，完成一步需要1
    private func move(_ isSwipingToLeftDirection: Bool, xScale: CGFloat, isSwiped: Bool){
        
        //边界值
        if isSwiped && ((self.currentRenderingImageIndex <= 0 && !isSwipingToLeftDirection) || (self.currentRenderingImageIndex >= self.images.count - 1 && isSwipingToLeftDirection)){
            return
        }
        
        var offset = isSwipingToLeftDirection ?  -1 : 1
        if !isSwiped{
            offset = 0
        }
        
        let indexOffsetFromImageLayersToTemplates = (self.currentRenderingImageIndex - self.sideVisibleImageCount < 0) ? (self.sideVisibleImageCount + 1 + offset - self.currentRenderingImageIndex) : 1 + offset
        
        for i in 0 ..< self.imageLayers.count {
            let originLayer = self.imageLayers.object(at: i) as! CALayer
            let targetTemplate = self.templateLayers.object(at: i + indexOffsetFromImageLayersToTemplates) as! CALayer
            
            originLayer.zPosition = targetTemplate.zPosition
            
            var scale = self.sideVisibleImageScale!
            let scaleOffset = abs(self.sideVisibleImageScale-self.middleImageScale)*abs(xScale)  //0 ---> 0.25(0.7-0.45)
            let indexX = i + indexOffsetFromImageLayersToTemplates - 1
            var dltX = self.gapAmongSideImages
            
            //目前两边向中间
            if (indexX == self.sideVisibleImageCount) {
                scale = self.sideVisibleImageScale+scaleOffset
                
                var transR = leftRadian
                if isSwipingToLeftDirection{
                    transR = rightRadian
                }
                transR = transR*(1-abs(xScale))
                let r = CATransform3DMakeRotation(transR, 0, 1, 0)
                originLayer.transform = CATransform3DScale(r, scale, scale, 1)
                dltX = self.gapBetweenMiddleAndSide
                
                self.currentImagesIndex = i
                //目前中间向右边
            } else if ((indexX == self.sideVisibleImageCount - 1) && isSwipingToLeftDirection){
                scale = self.middleImageScale-scaleOffset
                
                let transR = leftRadian*(abs(xScale))
                let r = CATransform3DMakeRotation(transR, 0, 1, 0)
                originLayer.transform = CATransform3DScale(r, scale, scale, 1)
                dltX = self.gapBetweenMiddleAndSide
                //目前中间向左边
            } else if (indexX == self.sideVisibleImageCount + 1) && !isSwipingToLeftDirection{
                scale = self.middleImageScale-scaleOffset
                
                let transR = rightRadian*(abs(xScale))
                let r = CATransform3DMakeRotation(transR, 0, 1, 0)
                originLayer.transform = CATransform3DScale(r, scale, scale, 1)
                dltX = self.gapBetweenMiddleAndSide
            }
            
            originLayer.position.x = targetTemplate.position.x+xScale*(dltX) + (xScale>0 ? -dltX : dltX)
        }
    }
    
    
//=============================================超出范围=============================
    private func moveOneStep(_ isSwipingToLeftDirection: Bool){
        //边界值
        if ((self.currentRenderingImageIndex <= 0 && !isSwipingToLeftDirection) || (self.currentRenderingImageIndex >= self.images.count - 1 && isSwipingToLeftDirection)){
            return
        }
        
        if (isSwipingToLeftDirection){
            
            //超出边界时，删除
            if(self.currentRenderingImageIndex >= self.sideVisibleImageCount){
                let removeLayer = self.imageLayers.object(at: 0) as! CALayer
                self.imageLayers.remove(removeLayer)
                removeLayer.removeFromSuperlayer()
                self.currentImagesIndex = self.currentImagesIndex - 1
            }
            
            //新增
            let num = self.images.count - self.sideVisibleImageCount - 1
            if (self.currentRenderingImageIndex < num){
                let candidateImage = self.images.object(at: self.currentRenderingImageIndex  + self.sideVisibleImageCount + 1) as! UIImage
                let candidateLayer = self.getSingleImage(image: candidateImage, scale: self.sideVisibleImageScale)
                self.imageLayers.add(candidateLayer)
                
                self.setSingleImage(templateLayerIndex: self.templateLayers.count - 2, imageLayerIndex: nil, imageLayer: candidateLayer)
            }
            
        }else{
            
            if (self.currentRenderingImageIndex + self.sideVisibleImageCount <= self.images.count - 1) {
                let removeLayer = self.imageLayers.lastObject as! CALayer
                self.imageLayers.remove(removeLayer)
                removeLayer.removeFromSuperlayer()
            }
            
            //check out whether we need to add layer to left, only when (currentIndex - sideCount > 0)
            if (self.currentRenderingImageIndex > self.sideVisibleImageCount){
                
                let candidateImage = self.images.object(at: self.currentRenderingImageIndex - 1 - self.sideVisibleImageCount) as! UIImage
                let candidateLayer =  self.getSingleImage(image: candidateImage, scale: self.sideVisibleImageScale)
                self.imageLayers.insert(candidateLayer, at: 0)
                
                self.setSingleImage(templateLayerIndex: 1, imageLayerIndex: nil, imageLayer: candidateLayer)
                
                self.currentImagesIndex = self.currentImagesIndex + 1
            }
        }
        
        self.currentRenderingImageIndex = isSwipingToLeftDirection ? self.currentRenderingImageIndex + 1 : self.currentRenderingImageIndex - 1
        log.info("显示第\(Int(self.currentRenderingImageIndex))张")
        log.info("数组中的第\(Int(self.currentImagesIndex))张")
    }
    
    
    
//=============================================设置图片数组 预位置=============================
    private func setupTemplateLayers(){
        
        let centerX = self.bounds.size.width/2
        let centerY = self.bounds.size.height/2
        
        //left
        for i in 0 ..< self.sideVisibleImageCount+1{
            let layer = CALayer()
            let x = centerX - gapBetweenMiddleAndSide - gapAmongSideImages * CGFloat(self.sideVisibleImageCount - i)
            layer.position = CGPoint(x: x, y: centerY)
            layer.zPosition = CGFloat(i) * zPositionGap
            let r = CATransform3DMakeRotation(leftRadian, 0, 1, 0)
            layer.transform = CATransform3DScale(r, self.sideVisibleImageScale, self.sideVisibleImageScale, 1)
            
            self.templateLayers.add(layer)
        }
        
        // middle
        let layer = CALayer()
        layer.position = CGPoint(x: centerX, y: centerY)
        layer.zPosition = CGFloat(self.sideVisibleImageCount+1) * zPositionGap
        let r = CATransform3DMakeRotation(0, 0, 1, 0)
        let rr = CATransform3DTranslate(r, 0, 0, 0)
        layer.transform = CATransform3DScale(rr, self.middleImageScale, self.middleImageScale, 1)
        self.templateLayers.add(layer)
        
        
        //right
        for i in 0 ..< self.sideVisibleImageCount+1{
            let layer = CALayer()
            let x = centerX + gapBetweenMiddleAndSide + gapAmongSideImages * CGFloat(i)
            layer.position = CGPoint(x: x, y: centerY)
            layer.zPosition = CGFloat(self.sideVisibleImageCount-i) * zPositionGap
            let r = CATransform3DMakeRotation(rightRadian, 0, 1, 0)
            layer.transform = CATransform3DScale(r, self.sideVisibleImageScale, self.sideVisibleImageScale, 1)
            self.templateLayers.add(layer)
        }
    }
    
    
//=============================================设置图片数组，加载=============================
    private func setUpImages(){
        let startingImageIndex = (self.currentRenderingImageIndex - self.sideVisibleImageCount <= 0) ? 0 : self.currentRenderingImageIndex - self.sideVisibleImageCount
        let endImageIndex = (self.currentRenderingImageIndex + self.sideVisibleImageCount < self.images.count )  ? (self.currentRenderingImageIndex + self.sideVisibleImageCount) : (self.images.count - 1)
        
        for i in startingImageIndex ..< endImageIndex+1{
            let image = self.images[i] as! UIImage
            let scale = i==currentRenderingImageIndex ? self.middleImageScale : self.sideVisibleImageScale
            let imageLayer = self.getSingleImage(image: image, scale: scale!)
            self.imageLayers.add(imageLayer)
        }
        
        let indexOffsetFromImageLayersToTemplates = (self.currentRenderingImageIndex - self.sideVisibleImageCount < 0) ? (self.sideVisibleImageCount + 1 - self.currentRenderingImageIndex) : 1
        for i in 0 ..< self.imageLayers.count{
            self.setSingleImage(templateLayerIndex: i + indexOffsetFromImageLayersToTemplates, imageLayerIndex: i, imageLayer: nil)
        }
    }
    
    
    @objc private func tapedImage(_ sender: UITapGestureRecognizer){
        let touchPoint = sender.location(in: self)
        
        for subView in self.layer.sublayers!{
            
            if (subView.presentation()?.hitTest(touchPoint)) != nil {
                let index = self.imageLayers.index(of: subView)
                log.info("点击第\(Int(self.currentRenderingImageIndex + index - self.currentImagesIndex))张")
                
                guard index != self.currentImagesIndex else {
                    return
                }
                
                let dltIndex = index - self.currentImagesIndex
                let d = dltIndex>0 ? true : false
                for _ in 0 ..< abs(dltIndex){
                    self.move(d, xScale: 0.5, isSwiped: true)
                    self.move(d, xScale: 1, isSwiped: true)
                    self.moveOneStep(d)
                }
                break
            }
        }
    }
    
    
    
//=============================================UI=============================
    
    private func setSingleImage(templateLayerIndex: Int, imageLayerIndex: Int?, imageLayer: CALayer?){
        
        let correspondingTemplateLayer = self.templateLayers.object(at: templateLayerIndex) as! CALayer
        
        var imageView = CALayer()
        
        if let index = imageLayerIndex{
            imageView = self.imageLayers.object(at: index) as! CALayer
        }
        
        if let layer = imageLayer{
            imageView = layer
        }
        
        
        imageView.position = correspondingTemplateLayer.position
        imageView.transform = correspondingTemplateLayer.transform
        imageView.zPosition = correspondingTemplateLayer.zPosition
        
        self.layer.addSublayer(imageView)
    }
    
    
    private func getSingleImage(image: UIImage, scale: CGFloat) -> CALayer{
        let view = CALayer()
        view.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewWidth*2)
        
        let imageView = CALayer()
        imageView.frame.size = CGSize(width: view.frame.width, height: view.frame.width)
        imageView.position = CGPoint(x: view.frame.width/2, y: view.frame.height/4)
        imageView.contents = image.cgImage
        view.addSublayer(imageView)
        
        // 制作reflection
        let reflectLayer = CALayer()
        reflectLayer.contents = imageView.contents
        reflectLayer.bounds = imageView.bounds
        reflectLayer.position = CGPoint(x: view.frame.width/2, y: view.frame.height*3/4-2)
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
        view.addSublayer(reflectLayer)
        view.transform =  CATransform3DMakeScale(scale, scale, 1)
        return view
    }
}
