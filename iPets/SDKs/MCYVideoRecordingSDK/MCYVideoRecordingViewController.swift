//
//  MCYVideoRecordingViewController.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/16.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class MCYVideoRecordingViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    //  最常视频录制时间，单位 秒
    let MaxVideoRecordTime = 6000 * 3
    
    //  MARK: - Properties ，
    //  视频捕获会话，他是 input 和 output 之间的桥梁，它协调着 input 和 output 之间的数据传输
    let captureSession = AVCaptureSession()
    //  视频输入设备，前后摄像头
    var camera: AVCaptureDevice?
    //  展示界面
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    //  HeaderView
    var headerView: UIView!
    
    //  音频输入设备
    let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    //  将捕获到的视频输出到文件
    let fileOut = AVCaptureMovieFileOutput()
    
    //  开始、停止按钮
    var startButton, stopButton: UIButton!
    var saveBtn: UIButton!
    
    //  前后摄像头转换、闪光灯 按钮
    var cameraSideButton, flashLightButton: UIButton!
    //  录制时间 Label
    var totolTimeLabel: UILabel!
    //  录制时间Timer
    var timer: Timer?
    var secondCount = 0
    
    //  表示当时是否在录像中
    var isRecording = false
    
    var videoUrl: URL?
    
    
    //  MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  录制视频基本设置
        setupAVFoundationSettings()
        
        //  UI 布局
        setupButton()
        setupHeaderView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    //  MARK: - Private Methods
    func setupAVFoundationSettings() {
        camera = cameraWithPosition(AVCaptureDevicePosition.back)
        
        //  设置视频清晰度
        captureSession.sessionPreset = AVCaptureSessionPreset640x480
        
        //  添加视频、音频输入设备
        if let videoInput = try? AVCaptureDeviceInput(device: self.camera) {
            self.captureSession.addInput(videoInput)
        }
        if let audioInput = try? AVCaptureDeviceInput(device: self.audioDevice) {
            self.captureSession.addInput(audioInput)
        }
        
        //  添加视频捕获输出
        self.captureSession.addOutput(fileOut)
        
        //  使用 AVCaptureVideoPreviewLayer 可以将摄像头拍到的实时画面显示在 ViewController 上
        let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        videoLayer?.frame = view.bounds
        videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(videoLayer!)
        
        previewLayer = videoLayer
        
        //  启动 Session 回话
        self.captureSession.startRunning()
    }
    
    //  选择摄像头
    func cameraWithPosition(_ position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for item in devices as! [AVCaptureDevice] {
            if item.position == position {
                return item
            }
        }
        return nil
    }
    
    
    //  MARK: - UI Settings
    /**
     创建按钮
     */
    func setupButton() {
        //  开始按钮
        startButton = prepareButtons(btnTitle: "开始", btnSize: CGSize(width: 120, height: 50), btnCenter: CGPoint(x: view.bounds.size.width / 2 - 70, y: view.bounds.size.height - 50))
        startButton.backgroundColor = UIColor.red
        startButton.addTarget(self, action: #selector(onClickedStartButton(_:)), for: .touchUpInside)
        
        
        //  结束按钮
        stopButton = prepareButtons(btnTitle: "结束", btnSize: CGSize(width: 120, height: 50), btnCenter: CGPoint(x: view.bounds.size.width / 2 + 70, y: view.bounds.size.height - 50))
        stopButton.backgroundColor = UIColor.lightGray
        stopButton.isUserInteractionEnabled = false
        stopButton.addTarget(self, action: #selector(onClickedEndButton(_:)), for: .touchUpInside)
        
        //  保存按钮
        saveBtn = prepareButtons(btnTitle: "保存", btnSize: CGSize(width: 120, height: 50), btnCenter: CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height - 150))
        saveBtn.backgroundColor = UIColor.red
        saveBtn.isHidden = true
        saveBtn.addTarget(self, action: #selector(self.saveVideoToAlbum), for: .touchUpInside)
        
    }
    //  开始、结束按钮风格统一
    func prepareButtons(btnTitle title: String, btnSize size: CGSize, btnCenter center: CGPoint) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        button.center = center
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        view.addSubview(button)
        
        return button
    }
    
    //  headerView
    func setupHeaderView() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 64))
        headerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.addSubview(headerView)
        
        let centerY = headerView.center.y + 5
        let defaultWidth: CGFloat = 40
        
        //  返回、摄像头调整、时间、闪光灯四个按钮
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        backButton.setBackgroundImage(UIImage(named: "iw_back"), for: UIControlState())
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.center = CGPoint(x: 25, y: centerY)
        headerView.addSubview(backButton)
        
        cameraSideButton = UIButton(frame: CGRect(x: 0, y: 0, width: defaultWidth, height: defaultWidth * 68 / 99.0))
        cameraSideButton.setBackgroundImage(UIImage(named: "iw_cameraSide"), for: UIControlState())
        cameraSideButton.center = CGPoint(x: 100, y: centerY)
        cameraSideButton.addTarget(self, action: #selector(changeCamera(_:)), for: .touchUpInside)
        headerView.addSubview(cameraSideButton)
        
        totolTimeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        totolTimeLabel.center = CGPoint(x: headerView.center.x, y: centerY)
        totolTimeLabel.textColor = UIColor.white
        totolTimeLabel.textAlignment = .center
        totolTimeLabel.font = UIFont.systemFont(ofSize: 19)
        totolTimeLabel.text = "00:00:00"
        view.addSubview(totolTimeLabel)
        
        flashLightButton = UIButton(frame: CGRect(x: 0, y: 0, width: defaultWidth, height: defaultWidth * 68 / 99.0))
        flashLightButton.setBackgroundImage(UIImage(named: "iw_flashOn"), for: .selected)
        flashLightButton.setBackgroundImage(UIImage(named: "iw_flashOff"), for: UIControlState())
        flashLightButton.center = CGPoint(x: headerView.bounds.width - 100, y: centerY)
        flashLightButton.addTarget(self, action: #selector(switchFlashLight(_:)), for: .touchUpInside)
        headerView.addSubview(flashLightButton)
        
    }
    
    //  MARK: - UIButton Actions
    //  按钮点击事件
    //  点击开始录制视频
    func onClickedStartButton(_ startButton: UIButton) {
        hiddenHeaderView(true)
        saveBtn.isHidden = true
        self.setMaskView()
        
        //  开启计时器
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(videoRecordingTotolTime), userInfo: nil, repeats: true)
        
        if !isRecording {
            //  记录状态： 录像中 ...
            isRecording = true
            
            captureSession.startRunning()
            
            
            //  设置录像保存地址，在 Documents 目录下，名为 当前时间.mp4
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentDirectory = path[0] as String
            
            let nameStr = DateToToString.dateToStringBySelf(Date(), format: "yyyy_MM_dd_HHmmss")
            let filePath: String? = "\(documentDirectory)/\(nameStr).mp4"
            let fileUrl: URL? = URL(fileURLWithPath: filePath!)
            //  启动视频编码输出
            fileOut.startRecording(toOutputFileURL: fileUrl!, recordingDelegate: self)
            
            //  开始、结束按钮改变颜色
            startButton.backgroundColor = UIColor.lightGray
            stopButton.backgroundColor = UIColor.red
            startButton.isUserInteractionEnabled = false
            stopButton.isUserInteractionEnabled = true
        }
    }
    
    //  点击停止按钮，停止了录像
    func onClickedEndButton(_ endButton: UIButton) {
        hiddenHeaderView(false)
        
        //  关闭计时器
        timer?.invalidate()
        timer = nil
        secondCount = 0
        
        if isRecording {
            //  停止视频编码输出
            captureSession.stopRunning()
            
            //  记录状态： 录像结束 ...
            isRecording = false
            
            //  开始结束按钮颜色改变
            startButton.backgroundColor = UIColor.red
            stopButton.backgroundColor = UIColor.lightGray
            startButton.isUserInteractionEnabled = true
            stopButton.isUserInteractionEnabled = false
        }
        
        saveBtn.isHidden = false
    }
    
    /**
     将视频保存到本地
     
     - parameter videoUrl: 保存链接
     */
    func saveVideoToAlbum() {
        
        var theSuccess = true
        
        if let url = self.videoUrl {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }, completionHandler: { (success, error) in
                
                theSuccess = success
                
                mainQueue.async(execute: {    
                    if theSuccess {
                        ToastView().showToast("视频保存成功")
                        self.backAction()
                    } else {
                        ToastView().showToast("视频保存失败")
                    }
                })
            })
        }
    }

    
    //  录制时间
    func videoRecordingTotolTime() {
        secondCount += 1
        
        //  判断是否录制超时
        if secondCount == MaxVideoRecordTime {
            timer?.invalidate()
            let alertC = UIAlertController(title: "最常只能录制三十分钟呢", message: nil, preferredStyle: .alert)
            alertC.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            self.present(alertC, animated: true, completion: nil)
        }
        
        let hours = secondCount / 3600
        let mintues = (secondCount % 3600) / 60
        let seconds = secondCount % 60
        
        totolTimeLabel.text = String(format: "%02d", hours) + ":" + String(format: "%02d", mintues) + ":" + String(format: "%02d", seconds)
    }
    
    //  是否隐藏 HeaderView
    func hiddenHeaderView(_ isHidden: Bool) {
        if isHidden {
            UIView.animate(withDuration: 0.2, animations: {
                self.headerView.frame.origin.y -= 64
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.headerView.frame.origin.y += 64
            })
        }
    }
    
    //  返回上一页
    func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //  调整摄像头
    func changeCamera(_ cameraSideButton: UIButton) {
        cameraSideButton.isSelected = !cameraSideButton.isSelected
        captureSession.stopRunning()
        
        //  首先移除所有的 input
        if let  allInputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in allInputs {
                captureSession.removeInput(input)
            }
        }
        
        changeCameraAnimate()
        
        //  添加音频输出
        if let audioInput = try? AVCaptureDeviceInput(device: self.audioDevice) {
            self.captureSession.addInput(audioInput)
        }
        
        if cameraSideButton.isSelected {
            camera = cameraWithPosition(.front)
            if let input = try? AVCaptureDeviceInput(device: camera!) {
                captureSession.addInput(input)
            }
            
            if flashLightButton.isSelected {
                flashLightButton.isSelected = false
            }
            
        } else {
            camera = cameraWithPosition(.back)
            if let input = try? AVCaptureDeviceInput(device: camera!) {
                captureSession.addInput(input)
            }
        }
    }
    
    //  切换动画
    func changeCameraAnimate() {
        let changeAnimate = CATransition()
        changeAnimate.delegate = self as? CAAnimationDelegate
        changeAnimate.duration = 0.4
        changeAnimate.type = "oglFlip"
        changeAnimate.subtype = kCATransitionFromRight
        
        previewLayer.add(changeAnimate, forKey: "changeAnimate")
    }
    
    //  开启闪光灯
    func switchFlashLight(_ flashButton: UIButton) {
        if self.camera?.position == AVCaptureDevicePosition.front {
            return
        }
        let camera = cameraWithPosition(.back)
        if camera?.torchMode == AVCaptureTorchMode.off {
            do {
                try camera?.lockForConfiguration()
            } catch let error as NSError {
                logger.info("开启闪光灯失败 ： \(error)")
            }
            
            camera?.torchMode = AVCaptureTorchMode.on
            camera?.flashMode = AVCaptureFlashMode.on
            camera?.unlockForConfiguration()
            
            flashButton.isSelected = true
        } else {
            do {
                try camera?.lockForConfiguration()
            } catch let error as NSError {
                logger.info("关闭闪光灯失败： \(error)")
            }
            
            camera?.torchMode = AVCaptureTorchMode.off
            camera?.flashMode = AVCaptureFlashMode.off
            camera?.unlockForConfiguration()
            
            flashButton.isSelected = false
        }
    }
    
    var mask = UIControl()
    func setMaskView(){
        mask = UIControl(frame: view.bounds)
        mask.backgroundColor = UIColor.black
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        UIApplication.shared.keyWindow?.addSubview(mask)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(disMask))
        tapGesture.numberOfTapsRequired = 2
        mask.addGestureRecognizer(tapGesture)
    }
    
    func disMask(){
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        mask.removeFromSuperview()
    }
    
    //  MARK: - 录像代理方法
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        //  开始
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        //  结束
        self.videoUrl = outputFileURL
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return .portrait
    }
    
}
