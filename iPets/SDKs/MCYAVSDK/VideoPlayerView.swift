//
//  VideoPlayerView.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/20.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Cartography
import MediaPlayer

let videoPlayer = VideoPlayerView.shared

class VideoPlayerView: NSObject, AVPlayerViewControllerDelegate{
    
    static let shared = VideoPlayerView.init()
    private override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isPlayed: Bool? //是否播放了,主要是播放了，就不要加载了
    var indexPath: IndexPath?   //,传入indexPath，滑出屏幕就停止
    var isPlaying: Bool? //是否在播放
    var isLoaded: Bool? //是否加载成功了
    var videoUrl: String?  //视频地址
    var showCloseBtn: Bool! //是否显示关闭按钮，
    var mainView: UIView!
    
    fileprivate var playerLayer: AVPlayerLayer?
    fileprivate var session: AVAudioSession?
    fileprivate var loadingIndicator: UIActivityIndicatorView?
    
    fileprivate var picUrl: String?     // 封面图地址
    fileprivate var videoTitle: String? //视频标题
    
    fileprivate var controlView: UIView?     // 控制的蒙层
    fileprivate var controlBtn: UIButton?     // 控制的蒙层上的按钮
    fileprivate var playerItem: AVPlayerItem? //
    
    fileprivate var closeBtn: UIButton? //关闭视频按钮
    
    fileprivate var progressSlider: UISlider? //进度条
    fileprivate var progressBar: UIProgressView? //缓冲用
    fileprivate var totalTimeLB: UILabel? //视频总时间的label
    fileprivate var playBtn: UIButton? //播放按钮
    fileprivate var fullScreenBtn: UIButton? //全屏播放按钮
    fileprivate var barView: UIView? //进度的view
    
    fileprivate var fullBackView: UIView?     // 全屏时，返回的蒙层
    fileprivate var volumeSlider: UISlider? //音量进度条
    fileprivate var volumeView: UIView? //音量的view
    fileprivate var volumeViewSlider: UISlider?
    
    fileprivate var oldView: UIView? //全屏用的
    fileprivate var oldFrame: CGRect?
    fileprivate var controlMask: UIControl?
    
    fileprivate var isAnimationDone: Bool? //消失动画完成，不然单击时会出问题
    
    fileprivate var PlayerItemStatusContext = "PlayerItemStatusContext" //观察的context
    fileprivate var PlayerItemLoadedTimeRangesContext  = "PlayerItemLoadedTimeRangesContext"
    
    fileprivate var barDismissTimer: Timer? //进度条消失的timer
    
    //初始化播放器,传入indexPath，滑出屏幕就停止
    func setUpPlayer(_ frame: CGRect, videoUrl: String, indexPath: IndexPath?, videoTitle: String?, showCloseBtn: Bool){
        mainView = UIView()
        mainView.frame = frame
        mainView.backgroundColor = UIColor.black
        
        self.isPlayed = false
        self.isPlaying = false
        self.isLoaded = false
        self.videoUrl = videoUrl
        self.indexPath = indexPath
        self.videoTitle = videoTitle
        self.loadingIndicator = SetMaskView.getLoadingIndicator(self.mainView)
        self.showCloseBtn = showCloseBtn
        self.isAnimationDone = true
        
        self.setUpTimer()  //计时器-
        self.setUpPlayerControl() //视频 -
        self.setUpFuncView()  //控制的整个蒙层
        self.addPlayerItemObserver() //观察
        self.addScreenOrientationObserver() //屏幕旋转通知
        self.addEndNotification() //通知
        self.playOrNothing() //  开始播放
        self.colseBtn()
    }
    
    
//=====================================================================================================
///控制的整个蒙层
    
    fileprivate func setUpFuncView(){
        
        self.controlView = UIView()
        self.mainView.addSubview(self.controlView!)
        self.controlBtn = UIButton(type: .custom)
        
        SetMaskView.setControllView(self.controlView!, controlBtn: self.controlBtn!)
        
        //点击事件
        controlBtn!.addTarget(self, action: #selector(oneTab), for: .touchDown)
        controlBtn!.addTarget(self, action: #selector(twoTab), for: .touchDownRepeat)
        
        //进度条
        self.setProgressBar()
        
        // 全屏时，返回的蒙层
        setUpFullBackView()
    }
    
    //设置进度条
    func setProgressBar(){
        self.barView = UIView()
        self.playBtn = UIButton()
        self.totalTimeLB = UILabel()
        self.progressBar = UIProgressView()
        self.fullScreenBtn = UIButton()
        self.progressSlider = VideoSlider(frame: barView!.frame)
        
        //设置BarView
        self.controlView!.addSubview(barView!)
        
        SetMaskView.setBarView(barView, playBtn: self.playBtn, totalTimeLB: self.totalTimeLB, progressBar: self.progressBar!, fullScreenBtn: self.fullScreenBtn, progressSlider: self.progressSlider!)
        
        //播放按钮事件
        self.playBtn?.addTarget(self, action: #selector(pauseOrResume), for: .touchUpInside)
        
        //全屏播放按钮事件
        smallFullBtn()
        
        // 添加控制事件
        self.progressSlider?.addTarget(self,action:#selector(sliderValueChange(_:)), for: UIControlEvents.valueChanged)
        self.progressSlider?.addTarget(self,action:#selector(sliderDragUp(_:)), for: UIControlEvents.touchUpInside)
        
        hideBarView()
    }
    
    //全屏播放 , 手动旋转
    func fullScreenPaly(){
        removeScreenOrientationObserver() //先移除通知
        landscapeRightScreen(false)
        addScreenOrientationObserver() //添加旋转屏幕通知
        
        //播放时就启动
        if self.isPlaying == true {
            startTimer()
        }else{
            pauseTimer()
        }
    }
    
    //全屏时，显示成音量按钮
    func volumeBtn(){
        fullScreenBtn!.removeTarget(self, action: #selector(fullScreenPaly), for: .touchUpInside) //取消单击
        fullScreenBtn!.setImage(UIImage(named: "video_volume"), for: .normal)
        fullScreenBtn!.addTarget(self, action: #selector(changeVolume), for: .touchUpInside)
    }
    
    //小屏时的全屏按钮
    func smallFullBtn(){
        fullScreenBtn!.removeTarget(self, action: #selector(changeVolume), for: .touchUpInside) //取消单击
        fullScreenBtn!.setImage(UIImage(named: "video_fullScreen"), for: .normal)
        fullScreenBtn!.addTarget(self, action: #selector(fullScreenPaly), for: .touchUpInside)
    }
    
    //关闭按钮
    func colseBtn(){
        guard showCloseBtn else{
            return
        }
        
        self.closeBtn = UIButton()
        self.controlView?.addSubview(self.closeBtn!)
        SetMaskView.setCloseBtn(self.closeBtn!)
        self.closeBtn?.addTarget(self, action: #selector(stop), for: .touchUpInside)
    }

    //单击
    func oneTab(_ sender: UIButton, event: UIEvent) {
        self.perform(#selector(Tap(_:)), with: sender, afterDelay: 0.2)
    }
    
    //双击及点击事件
    func twoTab(_ sender: UIButton, event: UIEvent){
        //播放时才有惦记事件
        guard self.isLoaded == true else{
            return
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(Tap(_:)), object: sender) //取消单击
        pauseOrResume()  //双击点击事件
    }
    
    //单击点击事件
    func Tap(_ sender: UIButton){
        //播放时才有惦记事件
        guard self.isLoaded == true else{
            return
        }
        playOrNothing()
    }
    
    
    
//=====================================================================================================
//进度条
    
    /// 滑块拖动时的事件
    func sliderValueChange(_ sender: UISlider) {
        pause()
    }
    
    // 滑块拖动后的事件
    func sliderDragUp(_ sender: UISlider) {
        let time = Int64(Float(CMTimeGetSeconds(self.playerItem!.duration)) * (sender.value/100))
        let CMTime = CMTimeMake(time, 1)
        self.playerLayer?.player?.seek(to: CMTime, completionHandler: { (completion) in
            if completion{
               self.resume()
            }else{
                print("1")
            }
        })
    }
    
    //设置灰度条,缓冲
    func setTempBar(){
        // 计算缓存
        let timeInterval = self.availableDuration
        let duration = CMTimeGetSeconds(self.playerItem!.duration)
        
        self.progressBar!.setProgress(Float(timeInterval/duration), animated: true) //进度条设置值0-1
    }
    
    
    //隐藏进度条 或者显示 的动画  showStartTimer: 显示时是否启动timer
    func hideOrShowBarViewAnimation(_ showStartTimer: Bool){
        
        guard isAnimationDone == true else{
            return
        }
        
        isAnimationDone = false
        
        let dismissTime = TimeInterval(0.3)
        //消失
        if self.barView!.isHidden == false {
            UIView.animate(withDuration: dismissTime, animations: {
                self.barView!.frame.origin.y = self.barView!.y+self.barView!.height
                }, completion: { (_) in
                    self.barView!.isHidden = true
                    self.pauseTimer()
                    
                    self.isAnimationDone = true
            })
            
            if VideoFuncs.checkScreenOrientation() == 1{
                self.volumeView?.isHidden = true //如果调用 dismissVolumeView, removeFromSuperView会导致动画出问题
                UIView.animate(withDuration: dismissTime, animations: {
                    VideoFuncs.setStatusBar(true)
                    self.fullBackView?.frame.origin.y = -(self.fullBackView?.height)!
                    }, completion: { (_) in
                        self.fullBackView?.isHidden = true
                        self.volumeView = nil
                })
            }
            
        }else{ //显示
            self.barView!.isHidden = false
            UIView.animate(withDuration: dismissTime, animations: {
                self.barView!.frame.origin.y = self.barView!.y-self.barView!.height
                }, completion: { (_) in
                    if showStartTimer{
                        self.startTimer()
                    }else{
                        self.pauseTimer()
                    }
                    
                    self.isAnimationDone = true
            })
            
            if VideoFuncs.checkScreenOrientation() == 1{
                self.fullBackView?.isHidden = false
                VideoFuncs.setStatusBar(false)
                UIView.animate(withDuration: dismissTime, animations: {
                    self.fullBackView?.frame.origin.y = 0
                })
            }
        }
    }
    
    //隐藏进度条和状态栏，无动画的
    func hideBarView(){
        self.barView!.frame.origin.y = (self.controlView?.maxYY)!
        self.barView!.isHidden = true
    }
    
    //显示进度条
    func showBarView(){
        print("显示进度条")
        self.barView!.isHidden = false
        self.barView!.frame.origin.y = (self.controlView?.maxYY)! - self.barView!.height
        
        if isPlaying == true{
            startTimer()
        }else{
            pauseTimer()
        }
        
        //横屏时显示系统栏
        if VideoFuncs.checkScreenOrientation() == 1{
            VideoFuncs.setStatusBar(false)
        }
    }
    
    
//=====================================================================================================
// 全屏时，返回的蒙层
    
    func setUpFullBackView(){
        self.fullBackView = UIView()
        self.controlView!.addSubview(fullBackView!)
        
        let backBtn = UIButton()
        let backBtn1 = UIButton()
        var titleLb: UILabel?
        
        if self.videoTitle == nil{
            titleLb = nil
        }else{
            titleLb = UILabel()
        }
        
        SetMaskView.setFullBackView(self.fullBackView, backBtn: backBtn, backBtn1: backBtn1, titleLb: titleLb, titleStr: self.videoTitle)
        //返回按钮点击事件
        backBtn.addTarget(self, action: #selector(smallScreenPaly), for: .touchUpInside)
        backBtn1.addTarget(self, action: #selector(smallScreenPaly), for: .touchUpInside)
        
        self.fullBackView?.isHidden = true
    }
    
    //全屏播放 , 手动旋转
    func smallScreenPaly(){
        removeScreenOrientationObserver() //先移除通知
        portraitScreen(false)
        addScreenOrientationObserver() //添加旋转屏幕通知
        
        //播放时就启动
        if self.isPlaying == true {
            startTimer()
        }else{
            pauseTimer()
        }
    }
    
    //全屏时，调节音量
    func changeVolume(){
        if dismissVolumeView(){
            startTimer() //开始计时
            return
        }
        pauseTimer() //暂停计时
        
        self.volumeView = UIView()
        self.controlView?.addSubview(volumeView!)
        self.volumeSlider = VideoSlider(frame: volumeView!.frame)
        
        SetMaskView.setVolumeView(self.volumeView!, volumeSlider: self.volumeSlider)
        
        self.volumeSlider?.setValue(getSystemVolume(), animated: false)
        // 添加控制事件
        self.volumeSlider?.addTarget(self,action:#selector(changeVideoVolume(_:)), for: UIControlEvents.valueChanged)
    }
    
    //获取系统声音,可能立即获取不到
    func getSystemVolume() -> Float{
        //如果没获取到，在获取一次
        if self.volumeViewSlider == nil{
            self.volumeViewSlider = VideoFuncs.getSystemVolumeSlider()
        }
        let value = (self.volumeViewSlider?.value)!
        return value
    }
    
    //设置系统音量
    func setSystemVolume(_ value: Float){
        //如果没获取到，在获取一次
        if self.volumeViewSlider == nil{
            self.volumeViewSlider = VideoFuncs.getSystemVolumeSlider()
        }
        self.volumeViewSlider?.value = value
    }
    
    //音量条消失
    func dismissVolumeView() -> Bool{
        if volumeView != nil {
            volumeView?.isHidden = true
            volumeView?.removeFromSuperview()
            volumeView = nil
            
            return true
        }else{
            return false
        }
    }
    
    func  changeVideoVolume(_ sender: UISlider){
        let value = sender.value
        setSystemVolume(value)
    }
    
    
//=====================================================================================================
//旋转屏幕相关
    
    //添加屏幕旋转通知
    func addScreenOrientationObserver(){
        //感知设备方向 - 开启监听设备方向
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        // 屏幕旋转通知
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        //关闭设备监听
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    
    //删除屏幕旋转通知
    func removeScreenOrientationObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    //屏幕旋转通知事件
    func deviceOrientChange(){
        if self.barView?.isHidden == true{
            hideOrShowBarViewAnimation(false)
        }
        
        //检查屏幕方向
        if VideoFuncs.checkScreenOrientation() == 0{
            portraitScreen(true)
        }else if VideoFuncs.checkScreenOrientation() == 1{
            landscapeRightScreen(true)
        }
        
        //如果正在播放，就收起进度条
        if isPlaying == true{
            startTimer()
        }else{
            pauseTimer()
        }
    }
    
    
    //正常屏幕 auto: 是否是自动旋转，自动旋转的就不手动旋转屏幕了
    func portraitScreen(_ auto: Bool){
        let superView = self.mainView.superview!
        //已经选转了
        if !(superView.isKind(of: UIControl.self)){
            return
        }
        
        if !auto {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        
        self.fullBackView?.isHidden = true  //隐藏顶部返回栏
        smallFullBtn() //小屏时，显示全屏播放按钮
        if dismissVolumeView(){
            
        }
        //关闭按钮
        if let closebtn = self.closeBtn{
            closebtn.isHidden = false
        }
        
        self.mainView.removeFromSuperview()
        self.mainView.frame = oldFrame!
        resetPlyerFrame()
        oldView!.addSubview(self.mainView)
        
        superView.removeFromSuperview()
    }
    
    //像左右旋转屏幕
    func landscapeRightScreen(_ auto: Bool){
        
        //选转
        if !auto {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
        
        //已经选转了
        let superView = self.mainView.superview!
        if (superView.isKind(of: UIControl.self)){
            return
        }
        
        self.volumeViewSlider = VideoFuncs.getSystemVolumeSlider() //获取系统音量，不然太快了获取不到
        oldView = self.mainView.superview
        oldFrame = self.mainView.frame
        
        VideoFuncs.setStatusBar(false) //显示系统栏
        self.fullBackView?.isHidden = false //全屏返回view
        volumeBtn() //全屏播放按钮变成音量按钮
        //关闭按钮
        if let closebtn = self.closeBtn{
            closebtn.isHidden = true
        }
        
        //把视频加到mask上
        let frame = UIScreen.main.bounds
        self.mainView.bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.mainView.removeFromSuperview()
        
        controlMask = UIControl(frame: UIScreen.main.bounds)
        controlMask!.backgroundColor = UIColor.clear
        UIApplication.shared.keyWindow?.addSubview(controlMask!)
        controlMask!.addSubview(self.mainView)
        self.mainView.center = controlMask!.center
        
        resetPlyerFrame()
    }
    
//=====================================================================================================
//nstimer，计时器
    
    //设置进度条消失的timer
    func setUpTimer(){
        if self.barDismissTimer != nil {
            self.barDismissTimer = nil
        }
        
        self.barDismissTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideOrShowBarViewAnimation), userInfo: nil, repeats: true)
        pauseTimer()
    }
    
    //暂停计时器
    func pauseTimer(){
        self.barDismissTimer?.fireDate = Date.distantFuture //相当于暂停
    }
    
    func startTimer(){
        self.barDismissTimer?.fireDate = Date().addingTimeInterval(5)  //5s后执行
    }
    
    func stopTimer() {
        self.barDismissTimer?.invalidate()
        self.barDismissTimer = nil
    }
    
//=====================================================================================================
//视频本事，通知观察等
    
    //初始化player
    func setUpPlayerControl(){
        self.session = AVAudioSession.sharedInstance()
        do {
            _ = try
                self.session?.setCategory(AVAudioSessionCategoryPlayback)
        }catch _ as NSError{}
        
        self.playerItem = AVPlayerItem(url: URL(string: self.videoUrl!)!)
        
        let player = AVPlayer(playerItem: playerItem!)
        
        //创建AVPlayerLayer，必须把视频添加到AVPlayerLayer层，才能播放
        playerLayer = AVPlayerLayer()
        playerLayer!.player = player
        playerLayer!.videoGravity = AVLayerVideoGravityResizeAspect //视频填充模式
        resetPlyerFrame()
        self.mainView.layer.addSublayer(playerLayer!)
    }
    
    func resetPlyerFrame(){
        playerLayer!.frame = CGRect(x: 0, y: 0, width: self.mainView.width, height: self.mainView.height)
    }

    //pragma mark - KVO 观察AVPlayerItme的属性
    /**
     *  添加观察者开始观察 AVPlayer 的状态
     */
    func addPlayerItemObserver(){
        
        // status监控网络加载情况属性
        self.playerItem!.addObserver(self, forKeyPath: "status", options: .new, context: &PlayerItemStatusContext)
        self.playerItem!.addObserver(self, forKeyPath: "loadedTimeRanges", options:.new ,context: &PlayerItemLoadedTimeRangesContext)
    }
    
    
    /**
     *  移除观察者不再观察 AVPlayer 的状态
     */
    func removePlayerItemObserver(){
        if ((self.playerItem) != nil) {
            self.playerItem!.removeObserver(self, forKeyPath: "status")
            self.playerItem!.removeObserver(self, forKeyPath: "loadedTimeRanges")
            self.playerItem = nil
        }
    }
    
    //pragma mark - 监听播放器播放结束的通知
    func addEndNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(stop), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
    }
    
    //移除播放器播放结束的通知
    func removeEndNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //========================kvo通知, 进入后台在此进来回执行一次＝=================================
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == &PlayerItemStatusContext) {
            if (self.playerItem!.status == AVPlayerItemStatus.readyToPlay) {
                print("准备播放完毕，开始播放")
                self.loadingIndicator!.stopAnimating()
                
                self.isPlaying = true
                self.isLoaded = true
                self.monitoringPlayback(palyeritem: self.playerItem!)// 监听播放状态
                
                showBarView()
                
            }else if (self.playerItem!.status == AVPlayerItemStatus.unknown) {
                ToastView().showToast("播放视频失败！")
                self.stop()
            }else if (self.playerItem!.status == AVPlayerItemStatus.failed) {
                ToastView().showToast("加载视频失败！")
                self.stop()
            }
        }else if (context == &PlayerItemLoadedTimeRangesContext) {
            setTempBar() //设置灰度条,缓冲
        }
    }
    
    //监控播放情况
    func monitoringPlayback(palyeritem: AVPlayerItem){
        guard self.playerItem != nil else{
            return
        }
        
        self.playerLayer?.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: nil, using: { (time) in
            let currentSecond = Float(palyeritem.currentTime().value) / Float(palyeritem.currentTime().timescale) // 计算当前在第几秒
            let durition = Float(CMTimeGetSeconds(palyeritem.duration)) // 获取视频总长度
            
            self.progressSlider?.setValue((currentSecond/durition*100), animated: true)
            
            let nowTime = ChangeValue.timeToDate(TimeInterval(currentSecond))// 转换成播放时间(currentSecond)
            let totalTime = ChangeValue.timeToDate(TimeInterval(durition))// 总时间转换成播放时间
            self.totalTimeLB?.text = nowTime+"/"+totalTime //更新时间
            
        })
    }

    //计算缓存
    var availableDuration : TimeInterval {
        let loadedTimeRanges = self.playerLayer!.player!.currentItem!.loadedTimeRanges
        let timeRange = loadedTimeRanges.first!.timeRangeValue // 获取缓冲区域
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSeconds = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSeconds // 计算缓冲总进度
        return result
    }
    
    
//=====================================================================================================
//操作层的点击事件
    
    
    // 单击后时无反应还是播放，未加载视频，未播放
    func playOrNothing(){
        
        if self.isPlaying == false && self.isPlayed == false{
            play()
        }else{
            hideOrShowBarViewAnimation(true)
        }
    }
    
    
    // 双击后时暂停还是播放，加载了视频，播放中就暂停，暂停了就播放
    func pauseOrResume(){
        if self.isPlayed == true {
            if self.isPlaying == true{
                pause()
            }else{
                resume()
            }
        }
    }
    
    
    // 三击后结束, 只要加载了视频，就结束
    func stopOrNothing(){
        if self.isPlayed == true {
            stop()
        }
    }
    
//=====================================================================================================
// 视频的相关操作
    
    func play(){
        print("播放准备中。。。")
        self.isPlayed = true
        self.loadingIndicator!.startAnimating()
        //左下角播放按钮图片改变
        self.playBtn?.setImage(UIImage(named: "video_pause_btn"), for: .normal)
        
        playerLayer?.player?.play()
        
    }
    
    
    func pause(){
        print("暂停播放")
        self.isPlaying = false
        
        //暂停时一直显示进度条
        if self.barView?.isHidden == true {
            hideOrShowBarViewAnimation(false)
        }else{
            pauseTimer()
        }
        
        //左下角播放按钮图片改变
        self.playBtn?.setImage(UIImage(named: "video_play_btn"), for: .normal)
        
        playerLayer?.player?.pause()
    }
    
    
    func stop(){
        print("结束播放")
        self.isPlaying = false
        self.isPlayed = false
        
        removePlayerItemObserver()//删除观察者
        removeEndNotification() //删除通知
        removeScreenOrientationObserver()
        
        //检查屏幕方向
        if VideoFuncs.checkScreenOrientation() == 1{
            portraitScreen(false)
            VideoFuncs.setStatusBar(false)
        }
        
        self.stopTimer()
        self.playerLayer?.player?.pause()
        self.playerLayer?.player?.replaceCurrentItem(with: nil) //这个很重要，停止后，就不会继续缓冲了
        self.playerLayer?.player = nil
        self.playerLayer = nil
        self.playerLayer?.removeFromSuperlayer()
        self.mainView.removeFromSuperview()
        
        if controlMask != nil {
            controlMask?.removeFromSuperview()
            controlMask = nil
        }
    }
    
    //继续播放
    func resume(){
        print("继续播放")
        self.isPlaying = true
        
        //继续播放时要设置的东西
        //左下角播放按钮图片改变
        self.playBtn?.setImage(UIImage(named: "video_pause_btn"), for: .normal)
        
        //如果继续播放时，未隐藏，才执行
        if self.barView!.isHidden == false{
            startTimer()
        }
        
        playerLayer?.player?.play()
    }
}
