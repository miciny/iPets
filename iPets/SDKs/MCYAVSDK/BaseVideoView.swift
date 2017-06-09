//
//  BaseVideoView.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/19.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Kingfisher

class BaseVideoView: UIView{
    
    var wifiOnly = true
    
    fileprivate var videoUrl: String!  //视频地址
    
    fileprivate var picUrl: String?     // 封面图地址
    fileprivate var picAndLabelView: UIView? //封面图
    fileprivate var runtime: Int? //封面时间
    fileprivate var indexPath: IndexPath? //在cell中的位置
    fileprivate var videoTitle: String? //视频标题
    fileprivate var playView: UIView?
    
    fileprivate var showCloseBtn: Bool!  //显示关闭按钮
    
    //先显示图片,传入indexPath，滑出屏幕就停止
    func setUp(_ frame: CGRect, videoUrl: String, picUrl: String?, runtime: Int?, indexPath: IndexPath?, videoTitle: String?, showCloseBtn: Bool){
        self.backgroundColor = UIColor.black
        self.frame = frame
        
        self.videoUrl = videoUrl
        self.picUrl = picUrl
        self.runtime = runtime
        self.indexPath = indexPath
        self.videoTitle = videoTitle
        self.showCloseBtn = showCloseBtn
        self.setUpPic()
    }
    
    // 一开始显示图片
    func setUpPic(){
        
        self.picAndLabelView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(picAndLabelView!)
        
        // 一开始显示图片
        if let pic = self.picUrl{
            let picView = UIImageView.cellPicView()
            picView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            NetFuncs.showPic(imageView: picView, picUrl: pic)
            self.picAndLabelView!.addSubview(picView)
        }
        
        //播放图
        setUpPlayBtnView()
        
        //时间标签
        if let runTime = self.runtime {
            let runtimeStr = ChangeValue.runtimeToDate(runTime)
            let runtimeLb = UIView.labelView(String(runtimeStr))
            runtimeLb.frame.origin = CGPoint(x: (self.frame.width)/2-runtimeLb.frame.width/2, y: playView!.frame.maxY+10)
            self.picAndLabelView!.addSubview(runtimeLb)
        }
        
        //单击播放
        self.picAndLabelView!.isUserInteractionEnabled = true
        let playtap = UITapGestureRecognizer(target: self, action: #selector(playOrNothing))
        self.picAndLabelView!.addGestureRecognizer(playtap)
    }
    
    //一开始视频中间显示的播放图 和 其他显示的东西
    func setUpPlayBtnView(){
        
        playView = UIView()
        playView!.backgroundColor = UIColor.clear
        playView!.frame.size = CGSize(width: 70, height: 70)
        playView!.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.picAndLabelView!.addSubview(playView!)
        
        //黑色蒙层
        let lineWidth = CGFloat(1.5)
        let blackView = UIView()
        blackView.frame.origin = CGPoint(x: lineWidth/2, y: lineWidth/2)
        blackView.frame.size = CGSize(width: playView!.frame.width-lineWidth, height: playView!.frame.height-lineWidth)
        blackView.clipsToBounds = true
        blackView.layer.cornerRadius = blackView.frame.height/2
        blackView.backgroundColor = UIColor.black
        blackView.alpha = 0.6
        self.playView!.addSubview(blackView)
        
        // 画一个圈
        let startAngle: CGFloat = 0.0
        let endAngle: CGFloat = CGFloat(Double.pi*2)
        let center = CGPoint(x: playView!.bounds.midX, y: playView!.bounds.midY)
        let radius = playView!.frame.width/2 - lineWidth
        
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let outerLine = CAShapeLayer()
        outerLine.frame = playView!.bounds
        outerLine.path = path.cgPath
        outerLine.lineWidth = lineWidth
        outerLine.fillColor = UIColor.clear.cgColor
        outerLine.strokeColor = UIColor.white.cgColor
        
        playView!.layer.addSublayer(outerLine)
        playView!.layer.masksToBounds = true
        
        //中间的图片
        let playIcon = UIImageView()
        playIcon.image = UIImage(named: "video_play_btn")
        playIcon.frame.size = CGSize(width: 21, height: 21)
        playIcon.center = CGPoint(x: playView!.frame.width/2+1, y: playView!.frame.height/2)
        playView!.addSubview(playIcon)
        
    }
    
//=====================================================================================================
    //点击事件
    // 单击后时无反应还是播放，未加载视频，未播放
    func playOrNothing(){
        if wifiOnly{
            if NetFuncs.checkNet() != networkType.wifi {
                ToastView().showToast("请连接Wi-Fi")
                return
            }
        }
        
        if videoPlayer.isPlayed == true{
            videoPlayer.stop()
        }
        
        let playerFrame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        
        videoPlayer.setUpPlayer(playerFrame, videoUrl: self.videoUrl!, indexPath: self.indexPath,
                               videoTitle: self.videoTitle, showCloseBtn: self.showCloseBtn)
        self.addSubview(videoPlayer.mainView)
    }
}
