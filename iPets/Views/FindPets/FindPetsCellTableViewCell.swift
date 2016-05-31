//
//  MyCellTableViewCell.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/4.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class FindPetsCellTableViewCell: UITableViewCell, UIAlertViewDelegate{
    
    var delegate: FindPetsCellViewDelegate?
    var modelFrame: FindPetsCellFrameModel?
    
    var iconView = UIImageView()
    var nameView = UILabel()
    var textView = UILabel()
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
        self.timeView.textColor = UIColor.grayColor()
        self.contentView.addSubview(self.timeView)
        
        self.contentView.addSubview(self.moreView)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    func showCellWithModel(frameModel: FindPetsCellFrameModel){
        modelFrame = frameModel
        self.settingFrame()
        self.settingData()
    }
    
    //设置cell的数据
    func settingData(){
        let model = modelFrame?.myCellModel
        
        //是我就显示我的名字，如果是别人的，可以考虑循环查找
        //坑爹啊，这个地方耗时啊，滑动卡啊，也开个线程查找吧
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{
            //这里写需要放到子线程做的耗时的代码
            let info = self.loadIcon()
            let icon = info[0]
            let name = info[1]
            let isMy = info[2] as! Bool
            
            dispatch_async(dispatch_get_main_queue(), {
                self.iconView.image = icon as? UIImage //这里返回主线程，写需要主线程执行的代码
                self.nameView.text = name as? String //名字
                
                if isMy{
                    self.deleteView.setTitle("删除", forState: .Normal)
                    self.deleteView.backgroundColor = UIColor.clearColor()
                    self.deleteView.titleLabel?.font = timeFont
                    self.deleteView.setTitleColor(UIColor(red: 80/255, green: 100/255, blue: 150/255, alpha: 1), forState: .Normal)
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
        }
        
        //hide
        if isHide == true {
            self.hideView!.setTitle("全文", forState: .Normal)
            self.hideView!.setTitleColor(UIColor(red: 80/255, green: 100/255, blue: 150/255, alpha: 1), forState: .Normal)
            self.hideView!.titleLabel?.font = hideFont
            self.hideView!.backgroundColor = UIColor.clearColor()
            self.addSubview(self.hideView!)
        }
        
        //图片，异步加载，解决滑动页面卡的问题
        if (model!.picture != nil) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{
                //这里写需要放到子线程做的耗时的代码
                let findImage = self.loadPic()
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.showPic(findImage) //这里返回主线程，写需要主线程执行的代码
                })
            })
            
        }
        
        //时间lable
        self.timeView.text = DateToToString.getFindPetsTimeFormat(model!.date)
        
        //more
        self.moreView.image = UIImage(named: "More")
        
    }
    
    func showPic(pics: [UIImage]){
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
            
            self.pictureView[i].userInteractionEnabled = true
            self.pictureView[i].tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(FindPetsCellTableViewCell.selectedPic))
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
    func selectedPic(sender: UITapGestureRecognizer){
        let tag = (sender.view?.tag)! as Int
        
        //转化成相对于屏幕的绝对坐标
        var frames = [CGRect]()
        for i in 0 ..< self.pictureView.count {
            let frame = self.pictureView[i].superview!.convertRect(self.pictureView[i].frame, toView: self.superview?.superview?.superview)
            frames.append(frame)
        }

        
        var images = [UIImage]()
        
        let wait = WaitView()
        wait.showWait("加载中")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{
            for i in 0 ..< self.pictureView.count {
                let saveCache = SaveCacheDataModel()
                let imageHData = saveCache.loadImageFromFindPetsCacheDir("H"+(self.modelFrame?.myCellModel!.picture![i])!)
                
                let imageH = ChangeValue.dataToImage(imageHData)
                images.append(imageH)
            }
            dispatch_async(dispatch_get_main_queue(), {
                wait.hideView()
                self.delegate?.showPic(images, index: tag, frame: frames)
            })
        })
    }
    
    //设置cell显示的frame
    func settingFrame(){
        self.pictureView = [UIImageView]()
        if(modelFrame?.myCellModel?.picture != nil){
            let count = (modelFrame?.myCellModel?.picture?.count)! as Int
            for j in 0 ..< count {
                self.pictureView.append(UIImageView())
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
        let singleTextSize = sizeWithText("这是一行字", font: textFont, maxSize: CGSizeMake(Width, CGFloat(MAXFLOAT)))
        if (modelFrame?.myCellModel?.picture == nil && modelFrame!.textF.height/singleTextSize.height > rowLimited && isAll == false){
            isHide = true
            self.hideView = UIButton()
            self.hideView!.frame = modelFrame!.hideBtnF
            
            let tempX = modelFrame?.textF.origin.x
            let tempY = modelFrame?.textF.origin.y
            var tempSize = modelFrame!.textF.size
            tempSize.height = singleTextSize.height * rowLimited
            let tempFrame = CGRectMake(tempX!, tempY!, tempSize.width, tempSize.height)
            self.textView.frame =  tempFrame
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
