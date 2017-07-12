//
//  AudioRecorder.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/20.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecorder: NSObject {
    
    var path: String?
    var recorder: AVAudioRecorder? //录音器
    var recorderSeetingsDic: [String: Any]?

    init(path: String) {
        super.init()
        
        self.path = path
        self.setUpRecorder()
    }
    
    func setUpRecorder(){
        
        //初始化录音器
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        //设置录音类型
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        //设置支持后台
        try! session.setActive(true)
        
        //初始化字典并添加设置参数
        self.recorderSeetingsDic =
            [
                AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
                AVNumberOfChannelsKey: 2 as AnyObject, //录音的声道数，立体声为双声道
                AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue as AnyObject,
                AVEncoderBitRateKey : 320000 as AnyObject,
                AVSampleRateKey : 44100.0 as AnyObject //录音器每秒采集的录音样本数
        ]
    }
    
    func beginRecord(){
        //初始化录音器
        let url = URL(fileURLWithPath: self.path!)
        
        if recorder != nil{
            recorder = nil
        }
        
        do{
            recorder = try AVAudioRecorder(url: url, settings: self.recorderSeetingsDic!)
        }catch let e as NSError{
            log.info(e)
        }
        
        if recorder != nil {
            //开启仪表计数功能
            recorder!.isMeteringEnabled = true
            //准备录音
            recorder!.prepareToRecord()
            //开始录音
            recorder!.record()
            
            ToastView().showToast("开始录音")
        }
    }
    
    
    func endRecord() -> Int{
        //停止录音
        let time = Int((recorder?.currentTime)!)
        recorder?.stop()
        //录音器释放
        recorder = nil
        
        ToastView().showToast("结束录音")
        
        return time
    }
}
