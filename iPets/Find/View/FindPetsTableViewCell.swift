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
}

class FindPetsTableViewCell: UITableViewCell, UIAlertViewDelegate{
    
    var delegate: FindPetsCellViewDelegate?
    var modelFrame: FindPetsCellFrameModel?
    
    var iconView = UIImageView()
    var nameView = UILabel()
    var textView = CanCopyLabel()  //能复制
    var pictureView = [UIImageView]()
    var timeView = UILabel()
    var deleteView = UIButton()
    var moreView = UIImageView()
    var hideView: UIButton?
    let rowLimited = CGFloat(5)
    var isHide = false
    var isAll = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //用contentView加的话，清除的时候 不会被清掉
        self.contentView.addSubview(self.iconView)
        
        self.nameView.textColor = UIColor(red: 80/255, green: 100/255, blue: 150/255, alpha: 1)
        self.nameView.font = nameFont
        self.contentView.addSubview(self.nameView)
        
        self.timeView.font = timeFont
        self.timeView.textColor = UIColor.gray
        self.contentView.addSubview(self.timeView)
        
        self.contentView.addSubview(self.moreView)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    func showCellWithModel(_ frameModel: FindPetsCellFrameModel){
        modelFrame = frameModel
        self.settingFrame()
        self.settingData()
    }
    
    //设置cell的数据
    func settingData(){
        let model = modelFrame?.myCellModel
        
        //是我就显示我的名字，如果是别人的，可以考虑循环查找
        
        globalQueue.async(execute: {
            //这里写需要放到子线程做的耗时的代码
            let info = self.loadIcon()
            let icon = info[0]
            let name = info[1]
            let isMy = info[2] as! Bool
            
            mainQueue.async(execute: {
                self.iconView.image = icon as? UIImage //这里返回主线程，写需要主线程执行的代码
                self.nameView.text = name as? String //名字
                self.clickIcon()
                
                if isMy{
                    self.deleteView.setTitle("删除", for: UIControlState())
                    self.deleteView.backgroundColor = UIColor.clear
                    self.deleteView.titleLabel?.font = timeFont
                    self.deleteView.setTitleColor(UIColor(red: 80/255, green: 100/255, blue: 150/255, alpha: 1), for: UIControlState())
                    self.addSubview(self.deleteView)
                }
                
            })
        })
        
        //text
        if(model!.text != ""){
            self.textView.numberOfLines = 0
            self.textView.font = textFont
            self.addSubview(self.textView)
            self.textView.text = model!.text
            self.textView.canCopyLabelFrom = CanCopyLabelFrom.find
        }
        
        //hide
        if isHide == true {
            self.hideView!.setTitle("全文", for: UIControlState())
            self.hideView!.setTitleColor(UIColor(red: 80/255, green: 100/255, blue: 150/255, alpha: 1), for: UIControlState())
            self.hideView!.titleLabel?.font = hideFont
            self.hideView!.backgroundColor = UIColor.clear
            self.addSubview(self.hideView!)
        }
        
        //图片，异步加载，解决滑动页面卡的问题
        if (model!.picture != nil) {
            
            globalQueue.async(execute: {
                //这里写需要放到子线程做的耗时的代码
                let findImage = self.loadPic()
                
                mainQueue.async(execute: {
                    self.showPic(findImage) //这里返回主线程，写需要主线程执行的代码
                })
            })
            
        }
        
        //时间lable
        self.timeView.text = DateToToString.getFindPetsTimeFormat(model!.date)
        
        //more
        self.moreView.image = UIImage(named: "More")
        
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
        let name = self.nameView.text!
        self.delegate?.pushToPersonInfoView(name: name)
    }
    
//================================图片的展示=====================
    func showPic(_ pics: [UIImage]){
        let picViewCount = self.pictureView.count
        for i in 0 ..< picViewCount {
            self.pictureView[i].image = pics[i]
        }
    }
    
    //图片，异步加载，解决滑动页面卡的问题
    func loadPic() -> [UIImage]{
        let picViewCount = self.pictureView.count
        var findImage = [UIImage]()
        
        for i in 0 ..< picViewCount {
            
            let saveCache = SaveCacheDataModel()
            let imageData = saveCache.loadImageFromFindPetsCacheDir((modelFrame?.myCellModel!.picture![i])!)
            let image = ChangeValue.dataToImage(imageData)
            findImage.append(image)
            
            self.pictureView[i].isUserInteractionEnabled = true
            self.pictureView[i].tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.selectedPic))
            self.pictureView[i].addGestureRecognizer(tap)
        }
        
        return findImage
    }
    
    ////坑爹啊，这个地方耗时啊，滑动卡啊，也开个线程查找吧
    func loadIcon() -> NSArray{
        var icon = UIImage()
        var name = String()
        var isMy = Bool()
        
        if(myInfo.nickname == modelFrame?.myCellModel!.nickname){
            icon = myInfo.icon!
            name = myInfo.username!
            isMy = true
            
        }else{
            icon = UIImage(named: "defaultIcon")!
            name = ""
            isMy = false
        }
        return [icon, name, isMy]
    }
    
    //点击处理,展示图片
    func selectedPic(_ sender: UITapGestureRecognizer){
        let tag = (sender.view?.tag)! as Int
        
        //转化成相对于屏幕的绝对坐标
        var frames = [CGRect]()
        for i in 0 ..< self.pictureView.count {
            let frame = self.pictureView[i].superview!.convert(self.pictureView[i].frame, to: self.superview?.superview?.superview)
            frames.append(frame)
        }

        var images = [UIImage]()
        let wait = WaitView()
        wait.showWait("加载中")
        
        globalQueue.async(execute: {
            for i in 0 ..< self.pictureView.count {
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
        self.pictureView = [UIImageView]()
        if(modelFrame?.myCellModel?.picture != nil){
            let count = (modelFrame?.myCellModel?.picture?.count)! as Int
            for j in 0 ..< count {
                
                let myPic = UIImageView()
                myPic.contentMode = .scaleAspectFill  //比例不变，但是是填充整个ImageView
                myPic.clipsToBounds = true
                
                self.pictureView.append(myPic)
                self.pictureView[j].frame = modelFrame!.pictureF[j]
                self.addSubview(self.pictureView[j])
            }
        }
        
        self.iconView.frame = modelFrame!.iconF
        self.nameView.frame = modelFrame!.nameF
        self.textView.frame = modelFrame!.textF
        self.timeView.frame = modelFrame!.timeF
        self.moreView.frame = modelFrame!.moreF
        self.deleteView.frame = modelFrame!.deleteBtnF
        
        //判断是非显示全文
        let singleTextSize = sizeWithText("这是一行字", font: textFont, maxSize: CGSize(width: Width, height: CGFloat(MAXFLOAT)))
        if (modelFrame?.myCellModel?.picture == nil && modelFrame!.textF.height/singleTextSize.height > rowLimited && isAll == false){
            isHide = true
            self.hideView = UIButton()
            self.hideView!.frame = modelFrame!.hideBtnF
            
            let tempX = modelFrame?.textF.origin.x
            let tempY = modelFrame?.textF.origin.y
            var tempSize = modelFrame!.textF.size
            tempSize.height = singleTextSize.height * rowLimited
            let tempFrame = CGRect(x: tempX!, y: tempY!, width: tempSize.width, height: tempSize.height)
            self.textView.frame =  tempFrame
        }
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
