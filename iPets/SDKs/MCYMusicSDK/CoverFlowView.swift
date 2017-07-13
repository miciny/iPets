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
    
    private var DISTNACE_TO_MAKE_MOVE_FOR_SWIPE: CGFloat = 60
    private let imageViewWidth = CGFloat(300)
    
    private let leftRadian = CGFloat(Double.pi/3)
    private let rightRadian = CGFloat(-Double.pi/3)

    init(frame: CGRect, andImages: NSMutableArray, sideImageCount: Int, sideImageScale: CGFloat, middleImageScale: CGFloat) {
        super.init(frame: frame)
        
        self.frame = frame
        
        self.sideVisibleImageCount = sideImageCount
        self.sideVisibleImageScale = sideImageScale
        self.middleImageScale = middleImageScale
        
        self.currentRenderingImageIndex = 0
        self.images = NSMutableArray(array: andImages)
        self.imageLayers = NSMutableArray(capacity: self.sideVisibleImageCount * 2 + 1)
        self.templateLayers = NSMutableArray(capacity: (self.sideVisibleImageCount+1) * 2 + 1)
        
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
        
        var transformPerspective = CATransform3DIdentity
        transformPerspective.m34 = -1.0 / 500.0
        self.layer.sublayerTransform = transformPerspective
    }
    
    @objc private func handleGesture(_ recognizer: UIPanGestureRecognizer){
        
        if recognizer.state == UIGestureRecognizerState.changed{
            //get offset
            let offset = recognizer.translation(in: recognizer.view)
            let isSwipingToLeftDirection = (offset.x > 0) ? false : true
            
            if abs(offset.x) > DISTNACE_TO_MAKE_MOVE_FOR_SWIPE {
                self.move(isSwipingToLeftDirection, xScale: 1)
                self.moveOneStep(isSwipingToLeftDirection)
                recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            }else{
                self.move(isSwipingToLeftDirection, xScale: abs(offset.x)/DISTNACE_TO_MAKE_MOVE_FOR_SWIPE)
            }
        }else if recognizer.state == UIGestureRecognizerState.ended{
            
            let offset = recognizer.translation(in: recognizer.view)
            let isSwipingToLeftDirection = (offset.x > 0) ? false : true
            
            self.move(isSwipingToLeftDirection, xScale: 1)
            self.moveOneStep(isSwipingToLeftDirection)
        }
        
    }
    
    //xScale 比例，完成一步需要1
    private func move(_ isSwipingToLeftDirection: Bool, xScale: CGFloat){
        
        //边界值
        if ((self.currentRenderingImageIndex <= 0 && !isSwipingToLeftDirection) || (self.currentRenderingImageIndex >= self.images.count - 1 && isSwipingToLeftDirection)){
            return
        }
        
        let offset = isSwipingToLeftDirection ?  -1 : 1
        let indexOffsetFromImageLayersToTemplates = (self.currentRenderingImageIndex - self.sideVisibleImageCount < 0) ? (self.sideVisibleImageCount + 1 + offset - self.currentRenderingImageIndex) : 1 + offset
        
        for i in 0 ..< self.imageLayers.count {
            let originLayer = self.imageLayers.object(at: i) as! CALayer
            let targetTemplate = self.templateLayers.object(at: i + indexOffsetFromImageLayersToTemplates) as! CALayer
            
            originLayer.position = CGPoint(x: xScale*(targetTemplate.position.x-originLayer.position.x)+originLayer.position.x,
                                           y: xScale*(targetTemplate.position.y-originLayer.position.y)+originLayer.position.y)
            originLayer.zPosition = targetTemplate.zPosition
            
            
            var transR = leftRadian
            //set originlayer's bounds
            var scale = self.sideVisibleImageScale!
            
            let scaleOffset = abs(self.sideVisibleImageScale-self.middleImageScale)*xScale  //0 ---> 0.25(0.7-0.45)
            
            let indexX = i + indexOffsetFromImageLayersToTemplates - 1
            
            //目前两边向中间
            if (indexX == self.sideVisibleImageCount) {
                scale = self.sideVisibleImageScale+scaleOffset
                
                if isSwipingToLeftDirection{
                    transR = rightRadian
                }
                originLayer.transform = CATransform3DMakeRotation(transR*(1-xScale), 0, 1, 0)
                
            //目前中间向右边
            } else if ((indexX == self.sideVisibleImageCount - 1) && isSwipingToLeftDirection){
                scale = self.middleImageScale-scaleOffset
                originLayer.transform = CATransform3DMakeRotation(transR*(xScale), 0, 1, 0)
                
                print(originLayer.zPosition)
            //目前中间向左边
            } else if (indexX == self.sideVisibleImageCount + 1) && !isSwipingToLeftDirection{
                
                scale = self.middleImageScale-scaleOffset
                transR = rightRadian
                originLayer.transform = CATransform3DMakeRotation(transR*(xScale), 0, 1, 0)
            }
            
            originLayer.bounds = CGRect(x: 0, y: 0,
                                        width: imageViewWidth * scale,
                                        height: imageViewWidth * scale)
            
            self.adjustReflectionBounds(originLayer, scale: 1)
        }
    }
    
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
            }
            
            //新增
            let num = self.images.count - self.sideVisibleImageCount - 1
            if (self.currentRenderingImageIndex < num){
                let candidateImage = self.images.object(at: self.currentRenderingImageIndex  + self.sideVisibleImageCount + 1) as! UIImage
                
                let candidateLayer = CALayer()
                candidateLayer.contents = candidateImage.cgImage
                
                let scale = self.sideVisibleImageScale
                candidateLayer.bounds = CGRect(x: 0, y: 0, width: imageViewWidth * scale!, height: imageViewWidth * scale!)
                self.imageLayers.add(candidateLayer)
                
                let template = self.templateLayers.object(at: self.templateLayers.count - 2) as! CALayer
                candidateLayer.position = template.position
                candidateLayer.zPosition = template.zPosition
                candidateLayer.transform = template.transform
                
                //show the layer
                self.showImageAndReflection(candidateLayer)
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
                
                let candidateLayer = CALayer()
                candidateLayer.contents = candidateImage.cgImage
                
                let scale = self.sideVisibleImageScale
                candidateLayer.bounds = CGRect(x: 0, y: 0, width: imageViewWidth * scale!, height: imageViewWidth * scale!)
                self.imageLayers.insert(candidateLayer, at: 0)
                
                let template = self.templateLayers.object(at: 1) as! CALayer
                candidateLayer.position = template.position
                candidateLayer.zPosition = template.zPosition
                candidateLayer.transform = template.transform
                
                //show the layer
                self.showImageAndReflection(candidateLayer)
            }
        }
        
        self.currentRenderingImageIndex = isSwipingToLeftDirection ? self.currentRenderingImageIndex + 1 : self.currentRenderingImageIndex - 1
    }
    
    
    private func adjustReflectionBounds(_ layer: CALayer, scale: CGFloat){
        
        let reflectLayer = layer.sublayers?[0]
        
        self.scaleBounds(reflectLayer!, x: scale, y: scale)
        // set originLayer's reflection bounds
        self.scaleBounds((reflectLayer?.mask)!, x: scale, y: scale)
        // set originLayer's reflection bounds
        self.scaleBounds((reflectLayer?.sublayers?[0])!, x: scale, y: scale)
        // set originLayer's reflection position
        
        reflectLayer?.position = CGPoint(x: layer.bounds.size.width/2, y: layer.bounds.size.height*1.5)
        // set originLayer's mask position
        reflectLayer?.mask?.position = CGPoint(x: (reflectLayer?.bounds.size.width)!/2, y: (reflectLayer?.bounds.size.height)!/2)
        // set originLayer's reflection position
        reflectLayer?.sublayers?[0].position = CGPoint(x: (reflectLayer?.bounds.size.width)!/2, y: (reflectLayer?.bounds.size.height)!/2)
    }
    
    private func scaleBounds(_ layer: CALayer, x: CGFloat, y: CGFloat){
        layer.bounds = CGRect(x: 0, y: 0, width: layer.bounds.size.width*x, height: layer.bounds.size.height*y)
    }
    
    private func setupTemplateLayers(){
        
        let centerX = self.bounds.size.width/2
        let centerY = self.bounds.size.height/2
        
        let gapAmongSideImages: CGFloat = 30.0
        let gapBetweenMiddleAndSide: CGFloat = 100.0
        let zPositionGap = CGFloat(30.0)
        
        //left
        for i in 0 ..< self.sideVisibleImageCount+1{
            let layer = CALayer()
            let x = centerX - gapBetweenMiddleAndSide - gapAmongSideImages * CGFloat(self.sideVisibleImageCount - i)
            layer.position = CGPoint(x: x, y: centerY)
            layer.zPosition = CGFloat(i - self.sideVisibleImageCount - 1) * zPositionGap
            layer.transform = CATransform3DMakeRotation(leftRadian, 0, 1, 0)
            
            self.templateLayers.add(layer)
        }
        
        // middle
        let layer = CALayer()
        layer.position = CGPoint(x: centerX, y: centerY)
        self.templateLayers.add(layer)
        
        
        //right
        for i in 0 ..< self.sideVisibleImageCount+1{
            let layer = CALayer()
            let x = centerX + gapBetweenMiddleAndSide + gapAmongSideImages * CGFloat(i)
            layer.position = CGPoint(x: x, y: centerY)
            layer.zPosition = CGFloat(i + 1) * -zPositionGap
            layer.transform = CATransform3DMakeRotation(rightRadian, 0, 1, 0)
            
            self.templateLayers.add(layer)
        }
    }
    
    private func setUpImages(){
        let startingImageIndex = (self.currentRenderingImageIndex - self.sideVisibleImageCount <= 0) ? 0 : self.currentRenderingImageIndex - self.sideVisibleImageCount
        let endImageIndex = (self.currentRenderingImageIndex + self.sideVisibleImageCount < self.images.count )  ? (self.currentRenderingImageIndex + self.sideVisibleImageCount) : (self.images.count - 1)
        
        //step2: set up images that ready for rendering
        for i in startingImageIndex ..< endImageIndex+1{
            let image = self.images[i] as! UIImage
            let imageLayer = CALayer()
            imageLayer.contents = image.cgImage
            let scale = (i == self.currentRenderingImageIndex) ? self.middleImageScale : self.sideVisibleImageScale
            imageLayer.bounds = CGRect(x: 0, y: 0, width: imageViewWidth * scale!, height: imageViewWidth * scale!)
            self.imageLayers.add(imageLayer)
        }
        
        //step3 : according to templates, set its geometry info to corresponding image layer
        //1 means the extra layer in templates layer
        let indexOffsetFromImageLayersToTemplates = (self.currentRenderingImageIndex - self.sideVisibleImageCount < 0) ? (self.sideVisibleImageCount + 1 - self.currentRenderingImageIndex) : 1
        
        for i in 0 ..< self.imageLayers.count{
            let correspondingTemplateLayer = self.templateLayers.object(at: i + indexOffsetFromImageLayersToTemplates) as! CALayer
            let imageLayer = self.imageLayers.object(at: i) as! CALayer
            
            imageLayer.position = correspondingTemplateLayer.position
            imageLayer.zPosition = correspondingTemplateLayer.zPosition
            imageLayer.transform = correspondingTemplateLayer.transform
            
            self.showImageAndReflection(imageLayer)
        }
    }
    
    private func showImageAndReflection(_ layer: CALayer){
        
        // 制作reflection
        let reflectLayer = CALayer()
        reflectLayer.contents = layer.contents
        reflectLayer.bounds = layer.bounds
        reflectLayer.position = CGPoint(x: layer.bounds.size.width/2, y: layer.bounds.size.height*1.5)
        reflectLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), 1, 0, 0)
        
        // 给该reflection加个半透明的layer
        let blackLayer = CALayer()
        blackLayer.backgroundColor = UIColor.black.cgColor
        blackLayer.bounds = reflectLayer.bounds
        blackLayer.position = CGPoint(x: blackLayer.bounds.size.width/2, y: blackLayer.bounds.size.height/2)
        blackLayer.opacity = 0.6
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
        layer.addSublayer(reflectLayer)
        // 加入UICoverFlowView的sublayers
        self.layer.addSublayer(layer)
    }
}





