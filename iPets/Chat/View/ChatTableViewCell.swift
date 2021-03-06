import UIKit

//点击头像进入个人信息页的代理
protocol ChatTableViewCellDelegate {
    
    func pushToPersonInfoView(name: String)
    
    func showPic(_ pic: [UIImage], index: Int, imageDate: [Date], frame: CGRect)
    
    func shareImage(image: UIImage)
    
    func tapedPic()
}

//信息体加用户头像
class ChatTableViewCell: UITableViewCell, MessageItemDelegate, AudioPlayerDelegate{
    
    var customView: UIView! //信息的view
    var bubbleView: BubbleItem! //背景气泡
    var avatarImage: UIImageView! //用户icon
    var msgItem: MessageItem!
    var cellDelegate: ChatTableViewCellDelegate?
    var chatName: String!
    
    var timer: MyTimer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: MessageItem, reuseIdentifier cellId: String, chatName: String){
        self.chatName = chatName
        self.msgItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildUserInterface()
    }
    
    func rebuildUserInterface(){
        //设置点击无反应
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundColor = UIColor.clear
        
        if (self.bubbleView == nil){
            self.bubbleView = BubbleItem(mtype: .mine, frame: CGRect.zero)
            self.addSubview(self.bubbleView.view)
        }
        
        let type =  self.msgItem.mtype //获得信息类型
        let width =  self.msgItem.view.frame.size.width //获得信息宽度
        let height =  self.msgItem.view.frame.size.height //获得信息高度
        
        //信息view的x，y
        var x =  (type == ChatType.someone) ? 0 : Width-width-self.msgItem.insets.left-self.msgItem.insets.right //设置x坐标
        var y:CGFloat = 0 //设置y坐标
        
        if (self.msgItem.user.username != ""){
            
            let thisUser =  self.msgItem.user
            
            //设置用户图片
            self.avatarImage = UIImageView(image: thisUser.icon)
            self.avatarImage.layer.cornerRadius = 3.0
            self.avatarImage.layer.masksToBounds = true
            self.avatarImage.layer.borderColor = UIColor(white:0.0 ,alpha:0.2).cgColor
            self.avatarImage.layer.borderWidth = 1.0
            
            //头像点击事件
            self.avatarImage.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapedIcon))
            self.avatarImage.tag = 1
            self.avatarImage.addGestureRecognizer(tap)
            
            //计算用户头像的x坐标
            let avatarX =  (type == ChatType.someone) ? 2 : Width-52 //x坐标 对方的为2 自己的为 Width-52
            let avatarY: CGFloat = 0 //y坐标为信息的高度，为了对其，设置相应值
            self.avatarImage.frame = CGRect(x: avatarX, y: avatarY, width: 50, height: 50)
            self.addSubview(self.avatarImage)
            
            //计算信息view的xy
            let delta =  self.frame.size.height - (self.msgItem.insets.top + self.msgItem.insets.bottom + height) //获取cell与整个信息高度的差
            if (delta > 0){ //cell与整个信息高度的差大于0 ， 就取这个值作为起始y
                y = delta
            }
            if (type == ChatType.someone){
                x += 54
            }
            if (type == ChatType.mine){
                x -= 54
            }
        }
        
        
        self.msgItem.delegate = self
        //判断气泡的类型和位置 , 图片就不显示气泡
        if self.msgItem.messageType == .text {
            self.bubbleView = BubbleItem.init(mtype: type, frame: CGRect(x: x, y: y, width: width + self.msgItem.insets.left + self.msgItem.insets.right, height: height + self.msgItem.insets.top + self.msgItem.insets.bottom))
            self.addSubview(self.bubbleView.view)
            
            //添加信息体的view
            self.customView = self.msgItem.view
            self.customView.frame = CGRect(x: self.msgItem.insets.left, y: self.msgItem.insets.top, width: width, height: height)
            self.bubbleView.view.addSubview(self.customView)
            
        }else if self.msgItem.messageType == .image {
            //添加信息体的view
            self.customView = self.msgItem.view
            self.customView.frame = CGRect(x: x+self.msgItem.insets.left, y: y+self.msgItem.insets.top, width: width, height: height)
            
            //图片点击事件
            self.customView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapedPic))
            self.customView.tag = 1
            self.customView.addGestureRecognizer(tap)
            self.addSubview(self.customView)
            
        }else if self.msgItem.messageType == .voice {
            
            self.bubbleView = BubbleItem.init(mtype: type, frame: CGRect(x: x, y: y, width: width + self.msgItem.insets.left + self.msgItem.insets.right, height: height + self.msgItem.insets.top + self.msgItem.insets.bottom))
            self.addSubview(self.bubbleView.view)
            
            //添加信息体的view
            self.customView = self.msgItem.view
            self.customView.frame = CGRect(x: self.msgItem.insets.left, y: self.msgItem.insets.top, width: width, height: height)
            self.bubbleView.view.addSubview(self.customView)
            
            
            let timeLb = UILabel()
            timeLb.font = UIFont.systemFont(ofSize: 13)
            timeLb.textColor = UIColor.black
            timeLb.textAlignment = .center
            timeLb.backgroundColor = UIColor.clear
            timeLb.text = (self.msgItem.voiceLong!) + "''"
            timeLb.frame.size = CGSize(width: 30, height: 25)
            
            if self.msgItem.mtype == .mine{
                timeLb.frame.origin = CGPoint(x: self.bubbleView.view.x-30, y: self.bubbleView.view.centerYY-15)
            }else{
                timeLb.frame.origin = CGPoint(x: self.bubbleView.view.maxXX, y: self.bubbleView.view.centerYY-15)
            }
            self.addSubview(timeLb)
            
            //图片点击事件
            self.bubbleView.view.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapVoice))
            self.bubbleView.view.tag = 2
            self.bubbleView.view.addGestureRecognizer(tap)
        }
    }

//========================================点击音频的处理理==================================
    @objc func tapVoice(){
        let plyer = AudioPlayer.shared
        if plyer.audioPath != nil && plyer.audioPath == msgItem.voicePath!{
            plyer.stopAudio()
        }else{
            plyer.stopAudio()
            plyer.delegate = self
            plyer.setUp(path: msgItem.voicePath!, autoPlay: false)
            plyer.playAudio()
        }
    }
    
    func beginPlay() {
        timer = MyTimer()
        timer?.setTimer(interval: 0.3, target: self, selector: #selector(changeVoiceImage), repeats: true)
        timer?.startTimer(interval: 0.3)
        self.msgItem.voiceImageView?.tag = 1
    }
    
    func finishPlay() {
        self.msgItem.voiceImageView?.image = UIImage(named: "SenderVoiceNodePlaying")
        timer?.stopTimer()
        timer = nil
    }
    
    @objc func changeVoiceImage(){
        if self.msgItem.voiceImageView?.tag == 1{
            self.msgItem.voiceImageView?.image = UIImage(named: "SenderVoiceNodePlaying01")
            self.msgItem.voiceImageView?.tag = 2
        }else if self.msgItem.voiceImageView?.tag == 2{
            self.msgItem.voiceImageView?.image = UIImage(named: "SenderVoiceNodePlaying02")
            self.msgItem.voiceImageView?.tag = 3
        }else if self.msgItem.voiceImageView?.tag == 3{
            self.msgItem.voiceImageView?.image = UIImage(named: "SenderVoiceNodePlaying03")
            self.msgItem.voiceImageView?.tag = 1
        }
    }
    
    
//========================================长安文字的代理==================================
    func lbLongPressed() {
        self.bubbleView.imageView.backgroundColor = UIColor.lightGray
    }
    
    func lbNoPressed() {
        self.bubbleView.imageView.backgroundColor = UIColor.clear
    }
    
    func imageLongPressed() {
        
    }
    
    func imageNoPressed() {
        
    }
    
    //分享图片
    func shareImage(image: UIImage) {
        self.cellDelegate?.shareImage(image: image)
    }
    

//========================================头像点击事件==================================
    @objc func tapedIcon(){
        self.cellDelegate?.pushToPersonInfoView(name: self.msgItem.user.nickname!)        //进入个人信息页
    }
    
    
//========================================图片点击事件==================================
    @objc func tapedPic(_ sender: UITapGestureRecognizer){
        self.cellDelegate?.tapedPic()
        
        let wait = WaitView()
        wait.showWait("加载中")
        var imageArray: [UIImage]?
        var imageDate: [Date]?
        var tag = 0 //点击的第几张图片
        var j = 0 //记录总图片数
        
        globalQueue.async(execute: {
            let frame = sender.view?.superview?.convert((sender.view?.frame)!, to: sender.view?.superview?.superview?.superview?.superview)
            let imageNameH = "H" + self.msgItem.imageName!
            imageArray = [UIImage]()
            imageDate = [Date]()
            //读取聊天的图片数据
            let chatsData = SaveDataModel()
            let chatCacheImages = SaveCacheDataModel()
            
            let singleChatData = chatsData.loadChatsDataFromTempDirectory(self.chatName+".plist", key: self.chatName)
            for i in 0 ..< singleChatData.count {
                if let image = singleChatData[i].chatImage{
                    let imageName = "H"+image
                    let imageData = chatCacheImages.loadImageFromChatCacheDir(self.chatName, imageName: imageName)
                    let image = ChangeValue.dataToImage(imageData)
                    imageArray!.append(image)
                    imageDate!.append(singleChatData[i].chatDate)
                    
                    if imageName == imageNameH {
                        tag = j
                    }
                    j += 1
                }
            }
            mainQueue.async(execute: {
                wait.hideView()
                self.cellDelegate?.showPic(imageArray!, index: tag, imageDate: imageDate!, frame: frame!)
                imageArray = nil
                imageDate = nil
            })
        })
    }
}
