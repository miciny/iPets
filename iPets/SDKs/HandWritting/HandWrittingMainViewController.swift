//
//  MainViewController.swift
//  Handwriting
//
//  Created by Collin Hundley on 5/1/17.
//  Copyright © 2017 Swift AI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HandWrittingMainViewController: UIViewController {
    
    // View
    let mainView = HandWrittingMainView()
    
    // Neural network
    var neuralNet: NeuralNet!
    
    // Drawing state variables
    /// The sketch brush width.
    fileprivate let brushWidth: CGFloat = 20
    /// The last point traced by the brush during drawing.
    fileprivate var lastDrawPoint = CGPoint.zero
    /// Traces a bounding box around the sketch for easy extraction.
    fileprivate var boundingBox: CGRect?
    /// Flag designating whether the user has dragged on the canvas during drawing.
    fileprivate var hasSwiped = false
    /// Flag designating whether the user is currently in the process of drawing.
    fileprivate var isDrawing = false
    /// Timer used for snapshotting the sketch.
    fileprivate var timer = Timer()
    
    
    fileprivate var markFlag = false
    fileprivate var markBtn: UIBarButtonItem?  //标记按钮
    fileprivate var netManager: SessionManager? //网络请求的manager
    fileprivate var markNumber = 0
    fileprivate var selectView: UploadNumberSelectorView?
    
    override func loadView() {
        self.title = "数字识别"
        self.view = mainView
        self.netManager = NetFuncs.getDefaultAlamofireManager()
        
        self.markBtn = UIBarButtonItem(title: "上传", style: .plain, target: self, action:
            #selector(self.markUpload))
        self.navigationItem.rightBarButtonItem = self.markBtn
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize neural network
        
        let myQueue = DispatchQueue(label: "myQueue")  //
        var nn: NeuralNet!
        let wait = WaitView()
        wait.showWait("加载中")
        myQueue.async {
            
            do {
                guard let url = Bundle.main.url(forResource: "neuralnet-mnist-trained", withExtension: nil) else {
                    fatalError("Unable to locate trained neural network file in bundle.")
                }
                nn = try NeuralNet(url: url)
            } catch {
                wait.hideView()
                fatalError("\(error)")
            }
            
            mainQueue.async {
                wait.hideView()
                self.neuralNet = nn
            }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}


// MARK: Touch handling

extension HandWrittingMainViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Reset swipe state tracker
        hasSwiped = false
        
        // Make sure the touch is inside the canvas
        guard mainView.canvasContainer.frame.contains(touch.location(in: mainView)) else {
            return super.touchesBegan(touches, with: event)
        }
        
        // Determine touch point
        let location = touch.location(in: mainView.canvas)
        
        // Reset bounding box if needed
        if boundingBox == nil {
            boundingBox = CGRect(x: location.x - brushWidth / 2,
                                 y: location.y - brushWidth / 2,
                                 width: brushWidth, height: brushWidth)
        }
        
        // Store draw location
        lastDrawPoint = location
        
        // Set drawing flag
        isDrawing = true
        
        // Invalidate timer
        timer.invalidate()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Make sure the touch is inside the canvas
        guard mainView.canvasContainer.frame.contains(touch.location(in: mainView)) else {
            hasSwiped = false
            return super.touchesMoved(touches, with: event)
        }
        
        // Determine touch point
        let currentPoint = touch.location(in: mainView.canvas)
        
        // Reset bounding box if needed
        if boundingBox == nil {
            boundingBox = CGRect(x: currentPoint.x - brushWidth,
                                 y: currentPoint.y - brushWidth,
                                 width: brushWidth, height: brushWidth)
        }
        
        // Draw a line from previous to current touch point
        if hasSwiped {
            drawLine(from: lastDrawPoint, to: currentPoint)
        } else {
            drawLine(from: currentPoint, to: currentPoint)
            hasSwiped = true
        }
        
        // Expand the bounding box to fit the extremes of the sketch
        if currentPoint.x < boundingBox!.minX {
            stretchBoundingBox(minX: currentPoint.x - brushWidth,
                               maxX: nil, minY: nil, maxY: nil)
        } else if currentPoint.x > boundingBox!.maxX {
            stretchBoundingBox(minX: nil,
                               maxX: currentPoint.x + brushWidth,
                               minY: nil, maxY: nil)
        }
        
        if currentPoint.y < boundingBox!.minY {
            stretchBoundingBox(minX: nil, maxX: nil,
                               minY: currentPoint.y - brushWidth,
                               maxY: nil)
        } else if currentPoint.y > boundingBox!.maxY {
            stretchBoundingBox(minX: nil, maxX: nil, minY: nil,
                               maxY: currentPoint.y + brushWidth)
        }
        
        // Store draw location
        lastDrawPoint = currentPoint
        
        // Invalidate timer
        timer.invalidate()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Make sure touch is inside canvas
        if mainView.canvasContainer.frame.contains(touch.location(in: mainView)) {
            if !hasSwiped {
                // Draw dot
                drawLine(from: lastDrawPoint, to: lastDrawPoint)
            }
        }
        
        // Start timer
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.timerExpired), userInfo: nil, repeats: false)
        
//        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] (_) in
//                self?.timerExpired()
//        }
        
        // We're no longer drawing
        isDrawing = false
        
        super.touchesEnded(touches, with: event)
    }
    
}


// MARK: Drawing and image manipulation


extension HandWrittingMainViewController {
    
    /// Draws a line on the canvas between the given points.
    fileprivate func drawLine(from: CGPoint, to: CGPoint) {
        // Begin graphics context
        UIGraphicsBeginImageContext(mainView.canvas.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        // Store current sketch in context
        mainView.canvas.image?.draw(in: mainView.canvas.bounds)
        
        // Append new line to image
        context?.move(to: from)
        context?.addLine(to: to)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1)
        context?.strokePath()
        
        // Store modified image back into image view
        mainView.canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        
        // End context
        UIGraphicsEndImageContext()
    }
    
    /// Crops the given UIImage to the provided CGRect.
    fileprivate func crop(_ image: UIImage, to: CGRect) -> UIImage {
        let img = image.cgImage!.cropping(to: to)
        return UIImage(cgImage: img!)
    }
    
    /// Scales the given image to the provided size.
    fileprivate func scale(_ image: UIImage, to: CGSize) -> UIImage {
        let size = CGSize(width: min(20 * image.size.width / image.size.height, 20),
                          height: min(20 * image.size.height / image.size.width, 20))
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height).integral
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.interpolationQuality = .none
        image.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Centers the given image in a clear 28x28 canvas and returns the result.
    fileprivate func addBorder(to image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 28, height: 28))
        image.draw(at: CGPoint(x: (28 - image.size.width) / 2,
                               y: (28 - image.size.height) / 2))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Updates the bounding box to stretch to the provided extremes.
    /// If `nil` is passed for any value, the box's current value will be preserved.
    fileprivate func stretchBoundingBox(minX: CGFloat?, maxX: CGFloat?, minY: CGFloat?, maxY: CGFloat?) {
        guard let box = boundingBox else { return }
        boundingBox = CGRect(x: minX ?? box.minX,
                             y: minY ?? box.minY,
                             width: (maxX ?? box.maxX) - (minX ?? box.minX),
                             height: (maxY ?? box.maxY) - (minY ?? box.minY))
    }
    
    /// Resets the canvas for a new sketch.
    fileprivate func clearCanvas() {
        // Animate snapshot box
        if let box = boundingBox {
            mainView.snapshotBox.frame = box
            mainView.snapshotBox.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            // Spring outward
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { 
                self.mainView.snapshotBox.alpha = 1
                self.mainView.snapshotBox.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
            }, completion: nil)
            // Spring back inward
            UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { 
                self.mainView.snapshotBox.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
        // Animate the sketch and bounding box away
        UIView.animate(withDuration: 0.1, delay: 0.4, options: [.curveEaseIn], animations: { 
            self.mainView.canvas.alpha = 0
            self.mainView.snapshotBox.alpha = 0
        }) { (_) in
            self.mainView.canvas.image = nil
            self.mainView.canvas.alpha = 1
        }
    }
    
}


// MARK: Classification

extension HandWrittingMainViewController {
    
    /// 停止计时器.
    @objc fileprivate func timerExpired() {
        // Perform classification
        classifyImage()
        // Reset bounding box
        boundingBox = nil
    }
    
    /// 格式化线条，显示结果.
    private func classifyImage() {
        // 结束后清除
        defer { clearCanvas() }
        
        guard let imageArray = scanImage() else { return }
        
        // 获取神经网络的结果
        do {
            let output = try neuralNet.infer(imageArray)
            if let (label, confidence) = label(from: output) {
                displayOutputLabel(label: label, confidence: confidence)
                
                //上传
                if self.markFlag{
                    if self.markNumber == label && confidence > 0.8{
                        let str = self.setData(data: imageArray)
                        self.uploadData(str: str)
                    }else{
                        self.confirmUpload(label, ok: {
                            let str = self.setData(data: imageArray)
                            self.uploadData(str: str)
                        })
                    }
                }
                
                
            } else {
                mainView.outputLabel.text = "Err"
            }
        } catch {
            print(error)
        }
        
        clearCanvas()
    }
    
    /// 扫描图片，返回Floats.
    private func scanImage() -> [Float]? {
        var pixelsArray = [Float]()
        guard let image = mainView.canvas.image, let box = boundingBox else {
            return nil
        }
        
        // 提取线条，去除白色外框
        let croppedImage = crop(image, to: box)
        
        // 缩放至 20px
        let scaledImage = scale(croppedImage, to: CGSize(width: 20, height: 20))
        
        // 加到 28x28 的盒子里
        let character = addBorder(to: scaledImage)
        
        // 显示
        mainView.networkInputCanvas.image = character
        
        // 提取像素 scaled/cropped image
        guard let cgImage = character.cgImage else { return nil }
        guard let pixelData = cgImage.dataProvider?.data else { return nil }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerRow = cgImage.bytesPerRow
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        
        // Iterate through
        var position = 0
        for _ in 0..<Int(character.size.height) {
            for _ in 0..<Int(character.size.width) {
                // 只管alpha component
                let alpha = Float(data[position + 3])
                // Scale alpha down to range [0, 1] and append to array
                pixelsArray.append(alpha / 255)
                // Increment position
                position += bytesPerPixel
            }
            if position % bytesPerRow != 0 {
                position += (bytesPerRow - (position % bytesPerRow))
            }
        }
        return pixelsArray
    }
    
    /// 从神经网络给的输入提取整数和准确度.
    private func label(from output: [Float]) -> (label: Int, confidence: Float)? {
        guard let max = output.max() else { return nil }
        return (output.index(of: max)!, max)
    }
    
    /// 显示返回的数字和准确度.
    private func displayOutputLabel(label: Int, confidence: Float) {
        
        // Only display label if confidence > 70%
        var labelStr = "\(label)"
        let confidenceStr = "准确率: \((confidence * 100).toString(decimalPlaces: 1))%"
        
        if confidence < 0.7{
            labelStr = "E"
        }
        
        // Animate labels outward and change text
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { 
            self.mainView.outputLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.mainView.confidenceLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.mainView.outputLabel.text = labelStr
            self.mainView.confidenceLabel.text = confidenceStr
        }, completion: nil)
        
        // Spring labels back to normal position
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { 
            self.mainView.outputLabel.transform = CGAffineTransform.identity
            self.mainView.confidenceLabel.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
}


//上传
extension HandWrittingMainViewController: UploadNumberSelectorViewDelegate{
    
    func markUpload(){
        if self.markFlag == false{
            self.markBtn?.title = "取消\(self.markNumber)"
            self.markFlag = true
            
            selectView = UploadNumberSelectorView(frame: self.view.bounds, delegate: self)
            self.view.addSubview(selectView!)
            
        }else{
            self.markBtn?.title = "上传"
            self.markFlag = false
            
            selectView?.removeFromSuperview()
            selectView = nil
        }
        
        
    }
    
    func setNumber(i: Int){
        self.markNumber = i
        self.markBtn?.title = "取消\(self.markNumber)"
    }
    
    
    func setData(data: [Float]) -> String{
        let array = NSMutableDictionary()
        
        array.setValue(data.description, forKey: "train_images")
        array.setValue(self.markNumber, forKey: "train_labels")
        
        return dicToJson(array)
    }
    
    func uploadData(str: String){
        let wait = WaitView()
        wait.showWait("上传中")
        
        let url = URL(string: "http://10.69.58.56:8181/mcyAI/uploadData")
        let paras = [
            "data": strToJson(str)
        ]
        
        //fuck  JSONEncoding !!!!!!!!!
        
        self.netManager?.request(url!, method: HTTPMethod.post, parameters: paras, encoding: JSONEncoding.default)
        .responseJSON(completionHandler: { (response) in
            switch response.result{
            case .success:
                wait.hideView()
                
                let code = String((response.response?.statusCode)!)
                if code == "200"{
                    logger.info("上传训练数据成功！")
                    ToastView().showToast("上传成功")
                    
                }else{
                    ToastView().showToast("上传失败")
                }
                
            case .failure:
                ToastView().showToast("请求失败")
                logger.info(response.result.error ?? "上传数据错误")
                
                wait.hideView()
            }
        })
    }
    
    
    func confirmUpload(_ realNumber: Int, ok: @escaping ()->()){
        
        let deleteAlertView = UIAlertController(title: "您确定要上传\(self.markNumber)？", message: "实际输入是\(realNumber)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler:{
            (UIAlertAction) -> Void in
            ok()
        })
        
        deleteAlertView.addAction(cancelAction)
        deleteAlertView.addAction(okAction)// 当添加的UIAlertAction超过两个的时候，会自动变成纵向分布
        self.present(deleteAlertView, animated: true, completion: nil)
    }
}
