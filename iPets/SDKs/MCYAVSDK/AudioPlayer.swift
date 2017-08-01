//
//  AudioPlayer.swift
//  Tetris
//
//  Created by maocaiyuan on 2017/3/9.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioPlayerDelegate {
    func beginPlay()
    
    func finishPlay()
}

class AudioPlayer: NSObject, AVAudioPlayerDelegate{
    
    static let shared = AudioPlayer.init()
    private override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var player: AVAudioPlayer? //播放器//不要把 AVAudioPlayer 当做局部变量 可能要用 AVAudioSession，否则木有声音啊
    var audioPath: String? //录音存储路径
    private var autoPlay: Bool! //是否自动播放
    var delegate: AudioPlayerDelegate?
    
    func setUp(path: String, autoPlay: Bool) {
        //初始化录音器
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        //设置录音类型
        try! session.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
        //设置支持后台
        try! session.setActive(true)
       
        self.audioPath = path
        self.autoPlay = autoPlay
    }
    
    //播放
    func playAudio(){
        guard self.audioPath != nil else {
            ToastView().showToast("没有音频路径")
            return
        }
        
        if FileManager.default.fileExists(atPath: self.audioPath!){
            
            let url = URL(fileURLWithPath: self.audioPath!)
            
            do{
                try self.player = AVAudioPlayer(contentsOf: url)
                
            }catch let error as NSError{
                logger.info("AVAudioPlayer error: \(error)")
            }
            
            if self.player == nil {
                ToastView().showToast("播放失败")
            }else{
                logger.info("开始播放")
                self.player?.delegate = self
                self.player?.play()
                self.delegate?.beginPlay()
            }

        }else {
            ToastView().showToast("文件已销魂")
            return
        }
        
    }
    
    //停止
    func stopAudio(){
        self.player?.stop()
        self.delegate?.finishPlay()
        audioPath = nil
        self.player = nil
    }
    
    ///
    /// AVAudioPlayerDelegate
    ///
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if autoPlay{
            self.playAudio() //重新开始
            return
        }
        self.delegate?.finishPlay()
        audioPath = nil
        self.player = nil
    }
    
}
