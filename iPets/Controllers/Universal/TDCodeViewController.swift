//
//  TDCodeViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/25.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class TDCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{

    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        
    }
    
    //设置title 等
    func setUpEles(){
        self.title = "二维码扫描"
        self.view.backgroundColor = UIColor.grayColor()
        
        //界面中间的扫描框
        let imageView = UIImageView(frame: CGRectMake(20, Height/2 - (Width-40)/2, Width-40, Width-40))
        imageView.image = UIImage(named:"pick_bg")
        self.view.addSubview(imageView)
        
        //扫描动画的线
        let animationLine = UIView(frame: CGRectMake(50, Height/2 - (Width-40)/2 + 20, Width-100, 5))
        animationLine.backgroundColor = UIColor.greenColor()
        let animation = scanAnimation()
        animationLine.layer.addAnimation(animation, forKey: "")
        self.view.addSubview(animationLine)
    }
    
    //动画
    func scanAnimation() -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.toValue = (Width-40) - 40
        animation.duration = 3
        animation.removedOnCompletion = false
        animation.repeatCount = 1/0
        return animation
    }
    
    //界面出现时，初始化摄像头
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCamera()
    }
    
    //界面消失时，关闭
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.session.running {
            self.session.stopRunning()
        }
    }
    
    //初始化摄像头
    func setupCamera(){
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error : NSError?
        let input: AVCaptureDeviceInput!
        
        //获取权限等
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        //如果设备不允许，显示提示并返回
        if (error != nil && input == nil) {
            let errorAlert = UIAlertView(title: "提醒", message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机", delegate: self, cancelButtonTitle: "确定")
            errorAlert.show()
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        //可以看到的镜头区域
        layer!.frame = CGRectMake(0, 0, Width, Height)
        self.view.layer.insertSublayer(self.layer!, atIndex: 0)
        
        let output = AVCaptureMetadataOutput()
        //设置响应区域
        //        output.rectOfInterest = CGRectMake(0, 0, 0, 0)
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
        }
        session.startRunning()
    }
    
    //扫描完成的代理方法
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var stringValue:String?
        
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as!AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            
            //获得扫面的东西
            if stringValue != nil{
                self.session.stopRunning()
            }
        }
        self.session.stopRunning()
        
        print(stringValue)
        
        let webVc = InternetExplorerViewController()
        webVc.url = stringValue
        self.navigationController?.pushViewController(webVc, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
