//
//  MusicPlayView.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/21.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import AVFoundation

/// 描述：播放模式
enum PlaybackMode {
    case orderMode  // 顺序播放
    case randomMode // 随机播放
    case singleMode // 单曲播放
}

class MusicPlayView: UIView, AVAudioPlayerDelegate{
    ///
    /// 公开属性
    ///
//    var songModel: HYBSongModel!             // 歌曲模型
//    var playingSongModel: HYBPlaySongModel!  // 正在播放的歌曲的模型
//    var selectedPlaylistItem: FSPlaylistItem!// 当前播放项
//    var delegate: AVAudioPlayerDelegate?  // 代理
    
    ///
    /// 私有属性
    ///
    fileprivate var audioPlayer: AVAudioPlayer!          // 音频播放类
    fileprivate var currentPlaybackTimeLabel: UILabel! // 当前回放时间标签
    fileprivate var totalPlaybackTimeLabel: UILabel!   // 总回放时间标签
    fileprivate var progressSlider: UISlider!          // 播放进度条
    
    fileprivate var playButton: UIButton!              // 播放按钮
    fileprivate var preButton: UIButton!               // 播放前一首按钮
    fileprivate var nextButton: UIButton!              // 播放下一首按钮
    fileprivate var playModeButton: UIButton!          // 播放模式
    fileprivate var playListButton: UIButton!          // 播放列表
    fileprivate var collectButton: UIButton!           // 收藏按钮
    fileprivate var downloadButton: UIButton!          // 下载按钮
    
    fileprivate var hasLRC = false // 是否有歌词
    fileprivate var isPlaying = 2 //0代表播放中，1代表暂停，2代表未播放
    fileprivate var progressTimer: Timer?
    fileprivate var playbackMode: PlaybackMode = PlaybackMode.orderMode // 默认为顺序播放
    fileprivate var playbackModeValue: Int = 0 // 默认为顺序播放
//    private var playlistItem: FSPlaylistItem?
    
    ///
    /// 生命周期函数
    ///
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        //音乐播放类
        audioPlayer = AVAudioPlayer()
        
        // 当前回放时间标签
        currentPlaybackTimeLabel = UIMaker.label(CGRect(x: 5, y: Height-100, width: 50, height: 25), title: "00:00")
        currentPlaybackTimeLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        currentPlaybackTimeLabel.textColor = UIColor.black
        self.addSubview(currentPlaybackTimeLabel)
        
        // 播放进度条
        progressSlider = UISlider(frame: CGRect(x: currentPlaybackTimeLabel.rightX(),y: Height-90,width: self.getwidth() - 110.0,height: 5))
        progressSlider.isContinuous = true
        progressSlider.minimumTrackTintColor = UIColor(red: 244.0 / 255.0, green: 147.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0)
        progressSlider.maximumTrackTintColor = UIColor.lightGray
        progressSlider.setThumbImage(UIImage(named: "player-progress-point-h"), for: UIControlState())
        self.addSubview(progressSlider)
        
        // 总回放时间标签
        totalPlaybackTimeLabel = UIMaker.label(CGRect(x: progressSlider.rightX(), y: Height-100, width: 50, height: 25), title: "00:00")
        totalPlaybackTimeLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        totalPlaybackTimeLabel.textColor = UIColor.black
        self.addSubview(totalPlaybackTimeLabel)
        
        // 播放按钮
        playButton = UIMaker.button("pasue", target: self, action: #selector(MusicPlayView.onPlayButtonClicked(_:)))
        playButton.setImage(UIImage(named: "pasueHight"), for: UIControlState.highlighted)
        playButton.frame = CGRect(x: (self.getwidth() - 64.0) / 2.0, y: self.getheight() - 64.0 - 10.0, width: 64, height: 64)
        self.addSubview(playButton)
        
        // 前一首按钮
        preButton = UIMaker.button("preSong", target: self, action: #selector(MusicPlayView.onPreviousButtonClicked(_:)))
        preButton.frame = CGRect(x: playButton.originX() - 60, y: playButton.originY() + 8, width: 48, height: 48)
        self.addSubview(preButton)
        
        // 下一首按钮
        nextButton = UIMaker.button("nextSong", target: self, action: #selector(MusicPlayView.onNextButtonClicked(_:)))
        nextButton.frame = CGRect(x: playButton.originX() + 70, y: playButton.originY() + 8, width: 48, height: 48)
        self.addSubview(nextButton)
        
        // 播放模式按钮
        playModeButton = UIMaker.button("order", target: self, action: #selector(MusicPlayView.onPlayModeButtonClicked(_:)))
        playModeButton.frame = CGRect(x: 5, y: preButton.originY(), width: 48, height: 48)
        self.addSubview(playModeButton)
        
        // 播放列表按钮
        playListButton = UIMaker.button("playList", target: self, action: #selector(MusicPlayView.onPlayListButtonClicked(_:)))
        playListButton.frame = CGRect(x: self.getwidth() - 5.0 - 48.0, y: preButton.originY(), width: 48, height: 48)
        self.addSubview(playListButton)
        
        let offsetX = (progressSlider.getwidth()-48*4)/3
        // 收藏按钮
        collectButton = UIMaker.button("collect", target: self, action: #selector(MusicPlayView.onCollectButtonClicked(_:)))
        collectButton.frame = CGRect(x: progressSlider.originX(), y: progressSlider.originY()-60, width: 48, height: 48)
        self.addSubview(collectButton)
        
        // 下载按钮
        downloadButton = UIMaker.button("downLoad", target: self, action: #selector(MusicPlayView.onDownloadButtonClicked(_:)))
        downloadButton.frame = CGRect(x: collectButton.rightX()+offsetX, y: collectButton.originY(), width: 48, height: 48)
        self.addSubview(downloadButton)
        downloadButton.isEnabled = false //是否可点击
    }
    
    ///
    /// 公开方法
    ///
    
    ///
    /// 描述：暂停音乐
    func pauseMusic(){
        
        self.audioPlayer.pause()
        self.stopTimer()
        isPlaying = 1
        playButton.setImage(UIImage(named: "pasue"), for: UIControlState())
        playButton.setImage(UIImage(named: "pasueHight"), for: UIControlState.highlighted)
    }
    
    /// 描述：继续音乐
    func resumeMusic(){
        
        self.audioPlayer.play()
        self.startTimer()
        isPlaying = 0
        playButton.setImage(UIImage(named: "play"), for: UIControlState())
        playButton.setImage(UIImage(named: "playHight"), for: UIControlState.highlighted)
    }
    
    ///
    /// 描述：点击播放
    func onPlayButtonClicked(_ sender: UIButton) {
        switch isPlaying{
        case 0:
            pauseMusic()
        case 1:
            resumeMusic()
        case 2:
            startToPlayMusic()
        default:
            break
        }
        
    }
    ///
    /// 描述：开始播放
    fileprivate func startToPlayMusic(){
        //播放
        let aacPath = Bundle.main.path(forResource: "A_comme_amour", ofType: "mp3")
        
        if FileManager.default.fileExists(atPath: aacPath!){
            audioPlayer = try! AVAudioPlayer(contentsOf: URL(string: aacPath!)!)
            if audioPlayer == nil {
                logger.info("播放失败")
            }else{
                self.audioPlayer.delegate = self //设置代理,为什么要在这里设置？？？？，要在init外设置？
                audioPlayer?.play()
                self.isPlaying = 0
                self.startTimer()
                
                playButton.setImage(UIImage(named: "play"), for: UIControlState()) //设置播放图片
                playButton.setImage(UIImage(named: "playHight"), for: UIControlState.highlighted)
                
                totalPlaybackTimeLabel.text = getFormateFromInt(audioPlayer.duration) //显示总时间
            }
        }else{
            logger.info("文件不存在")
        }
        
    }
    
    ///
    /// 描述：播放前一首
    func onPreviousButtonClicked(_ sender: UIButton) {
        // 暂不实现
    }
    
    ///
    /// 描述：播放下一首
    func onNextButtonClicked(_ sender: UIButton) {
        // 暂不实现
    }
    ///
    /// 描述：播放列表
    func onPlayListButtonClicked(_ sender: UIButton) {
        // 暂不实现
    }
    
    ///
    /// 描述：下载
    func onDownloadButtonClicked(_ sender: UIButton) {
        // 暂不实现
    }
    
    ///
    /// 描述：收藏
    func onCollectButtonClicked(_ sender: UIButton) {
        // 暂不实现
    }
    
    ///
    /// private 方法区
    ///
    
    ///
    /// 描述：开启定时器
    fileprivate func startTimer() {
        progressTimer = Timer(timeInterval: 0.005,
            target: self,
            selector: #selector(MusicPlayView.updatePlaybackProgress),
            userInfo: nil,
            repeats: true)
        RunLoop.current.add(progressTimer!, forMode: RunLoopMode.commonModes)
    }
    
    ///
    /// 描述：取消定时器
    fileprivate func stopTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    ///
    /// 描述：更新播放进度
    func updatePlaybackProgress() {
        if self.audioPlayer.duration == 0.0 {
            progressSlider.value = 0.0
        } else {
            progressSlider.minimumValue = 0.0
            progressSlider.maximumValue = Float(audioPlayer.duration)
            progressSlider.value = Float(audioPlayer.currentTime)
            
            currentPlaybackTimeLabel.text = getFormateFromInt(audioPlayer.currentTime)
        }
    }
    
    //一个传入秒数，弄成00:00形式
    func getFormateFromInt(_ time: TimeInterval) -> String{
        let mm = Int(time)/60
        let ss = Int(time)%60
        if(ss<10 && mm<10){
            return "0\(mm):0\(ss)"
        }else if(ss>10 && mm<10){
            return "0\(mm):\(ss)"
        }else{
            return "\(mm):\(ss)"
        }
    }
    
    ///
    /// 描述：修改播放模式
    func onPlayModeButtonClicked(_ sender: UIButton) {
        var name = ""
        var title = ""
        switch (self.playbackMode) {
        case .orderMode: // 当前是顺序播放，就切换成随机播放
            name = "random"
            title = "随机播放"
            self.playbackModeValue = 1
            self.playbackMode = .randomMode
            break
        case .randomMode:// 当前是顺序播放，就切换成单曲播放
            name = "lock"
            title = "单曲循环"
            self.playbackModeValue = 2
            self.playbackMode = .singleMode
            break
        default:
            name = "order"
            title = "顺序播放"
            self.playbackModeValue = 0
            self.playbackMode = .orderMode
            break
        }
        
        ToastView().showToast(title)
        self.playModeButton.setImage(UIImage(named: name), for: UIControlState())
    }
    
    
    /// 描述：停止当前播放状态
    func stopCurrentState() {
        if self.isPlaying != 2{
            self.downloadButton.isEnabled = false
            self.isPlaying = 2
            playButton.setImage(UIImage(named: "pasue"), for: UIControlState())
            playButton.setImage(UIImage(named: "pasueHight"), for: UIControlState.highlighted)
            totalPlaybackTimeLabel.text = "00:00"
            currentPlaybackTimeLabel.text = "00:00"
            progressSlider.value = 0
            self.audioPlayer.stop()
            self.stopTimer()
        }
    }
    
    ///
    /// AVAudioPlayerDelegate
    ///
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopCurrentState()
    }
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        pauseMusic()
    }

}
