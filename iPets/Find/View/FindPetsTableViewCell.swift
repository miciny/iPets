//
//  MyCellTableViewCell.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/4.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Kingfisher

//寻宠界面，点击图片事件
protocol FindPetsCellViewDelegate{
    func showPic(_ pic: [UIImage], index: Int, frame: [CGRect])
    
    func pushToPersonInfoView(name: String)
    
    func videoChanged()
}

class FindPetsTableViewCell: UITableViewCell, UIAlertViewDelegate{
    
    var delegate: FindPetsCellViewDelegate?
    var modelFrame: FindPetsCellFrameModel!
    
    var iconView = UIImageView()
    var nameView = UILabel()
    var textView: CanCopyLabel?  //能复制
    var pictureView: [UIImageView]?
    var deleteView: UIButton?
    var videoView: UIView?
    
    var timeView = UILabel()
    var moreView = UIImageView()
    var indexPath = IndexPath()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    func showCellWithModel(_ frameModel: FindPetsCellFrameModel, indexPath: IndexPath){
        self.modelFrame = frameModel
        self.indexPath = indexPath
        
        //在复用时，如果不置空，会有数据被重新利用
        textView = nil
        pictureView = nil
        deleteView = nil
        videoView = nil
        
        self.settingFrame()
        self.settingData()
    }
    
    //设置cell的数据
    func settingData(){
        
        //name icon
        self.setNameIcon()
        //text
        self.setText()
        
        //pic
        if self.pictureView != nil {
            globalQueue.async(execute: {
                //这里写需要放到子线程做的耗时的代码
                let findImage = self.loadPic()
                mainQueue.async(execute: {
                    self.showPic(findImage) //这里返回主线程，写需要主线程执行的代码
                })
            })
            
        }
        
        //video
        self.setVideo()
        
        //时间lable
        self.timeView.text = DateToToString.getFindPetsTimeFormat(modelFrame.myCellModel.date)
        
        //more
        self.moreView.image = UIImage(named: "More")
    }
    
    func setNameIcon(){
        
        //用contentView加的话，清除的时候 不会被清掉
        self.addSubview(self.iconView)
        
        self.nameView.textColor = UIColor(red: 80/255, green: 100/255, blue: 150/255, alpha: 1)
        self.nameView.font = nameFont
        self.addSubview(self.nameView)
        
        self.timeView.font = timeFont
        self.timeView.textColor = UIColor.gray
        self.addSubview(self.timeView)
        self.addSubview(self.moreView)
        
        globalQueue.async(execute: {
            //这里写需要放到子线程做的耗时的代码
            let icon = self.loadIcon()
            
            mainQueue.async(execute: {
                self.iconView.image = icon //这里返回主线程，写需要主线程执行的代码
                self.nameView.text = self.modelFrame.myCellModel.name //名字
                self.clickIcon()
                
                if let deleteBtn = self.deleteView{
                    deleteBtn.setTitle("删除", for: UIControlState())
                    deleteBtn.backgroundColor = UIColor.clear
                    deleteBtn.titleLabel?.font = timeFont
                    deleteBtn.setTitleColor(UIColor(red: 80/255, green: 100/255, blue: 150/255, alpha: 1), for: UIControlState())
                    self.addSubview(deleteBtn)
                }
            })
        })
    }
    
    func setText(){
        if let textView = self.textView{
            textView.numberOfLines = 0
            textView.font = textFont
            self.addSubview(textView)
            textView.text = modelFrame.myCellModel.text
            textView.canCopyLabelFrom = CanCopyLabelFrom.find
        }
    }

//===============================video==================
    func setVideo(){
        if let videoView = self.videoView{
            let avView = BaseVideoView()
            
            let videoURL = "http://newsapi.sina.cn/?resource=video/location&videoId=&videoPlayUrl=http%3A%2F%2Fus.sinaimg.cn%2F002Y3UUTjx07bIB3F08w010f11008G3e0k01.mp4%3FExpires%3D1496986166%26ssig%3Dqi4h8FL62f%26KID%3Dunistore%2Cvideo&docID=fyfzaaq5757350&col=&videoCate=weiborank&fromsinago=1&postt=news_news_video_6&from=6051193012"
            let picURL = "http://wx3.sinaimg.cn/large/7fa9a04fgy1fge7zzzit6j20dx07ugma.jpg"
            let time = 66000
            
            avView.setUp(CGRect(x: 0, y: 0, width: videoView.width, height: videoView.height),
                         videoUrl: videoURL,
                         picUrl: picURL,
                         runtime: time,
                         indexPath: self.indexPath,
                         videoTitle: nil,
                         showCloseBtn: true)
            
            videoView.addSubview(avView)
            avView.delegate = self
            
            self.addSubview(videoView)
        }
    }
    
    
//===============================点击头像和名字，进入个人信息页==================
    func clickIcon(){
        self.iconView.isUserInteractionEnabled = true
        self.nameView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(goPersonInfo))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(goPersonInfo))
        self.nameView.addGestureRecognizer(tap)
        self.iconView.addGestureRecognizer(tap1)
    }
    
    func goPersonInfo(){
        let name = self.modelFrame.myCellModel.nickname
        self.delegate?.pushToPersonInfoView(name: name)
    }
    
//================================图片的展示=====================
    func showPic(_ pics: [UIImage]){
        let picViewCount = self.pictureView!.count
        for i in 0 ..< picViewCount {
            self.pictureView![i].image = pics[i]
            //单机事件
            self.pictureView![i].isUserInteractionEnabled = true
            self.pictureView![i].tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.selectedPic))
            self.pictureView![i].addGestureRecognizer(tap)
        }
    }
    
    //图片，异步加载，解决滑动页面卡的问题
    func loadPic() -> [UIImage]{
        let picViewCount = self.pictureView!.count
        var findImage = [UIImage]()
        
        for i in 0 ..< picViewCount {
            
            let saveCache = SaveCacheDataModel()
            let imageData = saveCache.loadImageFromFindPetsCacheDir((modelFrame.myCellModel.picture![i]))
            let image = ChangeValue.dataToImage(imageData)
            findImage.append(image)
        }
        return findImage
    }
    
    //先这样吧
    func loadIcon() -> UIImage?{
        let icon = getUserIcon(nickname: modelFrame.myCellModel.nickname)
        return icon
    }
    
    //点击处理,展示图片
    func selectedPic(_ sender: UITapGestureRecognizer){
        let tag = (sender.view?.tag)! as Int
        //转化成相对于屏幕的绝对坐标
        var frames = [CGRect]()
        for i in 0 ..< self.pictureView!.count {
            let frame = self.pictureView![i].superview!.convert(self.pictureView![i].frame,
                                                                to: self.superview?.superview?.superview)
            frames.append(frame)
        }

        var images = [UIImage]()
        let wait = WaitView()
        wait.showWait("加载中")
        
        globalQueue.async(execute: {
            for i in 0 ..< self.pictureView!.count {
                let saveCache = SaveCacheDataModel()
                let imageHData = saveCache.loadImageFromFindPetsCacheDir("H"+(self.modelFrame?.myCellModel!.picture![i])!)
                
                let imageH = ChangeValue.dataToImage(imageHData)
                images.append(imageH)
            }
            mainQueue.async(execute: {
                wait.hideView()
                self.delegate?.showPic(images, index: tag, frame: frames)
                images = [UIImage]()
            })
        })
    }
    
//=================================设置cell显示的frame=================================
    func settingFrame(){
        
        // pic
        if let picFrames = modelFrame.pictureF{
            self.pictureView = [UIImageView]()
            let count = picFrames.count
            
            for j in 0 ..< count {
                
                let myPic = UIImageView()
                myPic.contentMode = .scaleAspectFill  //比例不变，但是是填充整个ImageView
                myPic.clipsToBounds = true
                
                self.pictureView!.append(myPic)
                self.pictureView![j].frame = picFrames[j]
                self.addSubview(self.pictureView![j])
            }
        }
        
        if let videoF = modelFrame.videoF{
            self.videoView = UIView()
            self.videoView?.frame = videoF
        }
        
        // text
        if let textF = modelFrame.textF{
            self.textView = CanCopyLabel()
            self.textView!.frame = textF
        }
        
        // delete
        if let deleteF = modelFrame.deleteBtnF{
            self.deleteView = UIButton()
            self.deleteView!.frame = deleteF
        }
        
        self.iconView.frame = modelFrame.iconF
        self.nameView.frame = modelFrame.nameF
        self.timeView.frame = modelFrame.timeF
        self.moreView.frame = modelFrame.moreF
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FindPetsTableViewCell: VideoPlayerViewDelegate{
    func prepareToPlay() {
        self.delegate?.videoChanged()
    }
    
    func stopVideo() {
        self.delegate?.videoChanged()
        
    }
    
    func resumeVideo() {
        self.delegate?.videoChanged()
        
    }
    
    func pauseVideo() {
        self.delegate?.videoChanged()
        
    }
}
