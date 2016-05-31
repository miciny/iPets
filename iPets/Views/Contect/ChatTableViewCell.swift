import UIKit

//信息体加用户头像
class ChatTableViewCell: UITableViewCell{
    
    var customView: UIView! //信息的view
    var bubbleView: BubbleItem! //背景气泡
    var avatarImage: UIImageView! //用户icon
    var msgItem: MessageItem!
    var delegate: SingleChatPicViewDelegate?
    var chatName: String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: MessageItem, reuseIdentifier cellId: String, chatName: String){
        self.chatName = chatName
        self.msgItem = data
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        rebuildUserInterface()
    }
    
    func rebuildUserInterface(){
        //设置点击无反应
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
        
        if (self.bubbleView == nil){
            self.bubbleView = BubbleItem(mtype: .Mine, frame: CGRectZero)
            self.addSubview(self.bubbleView.view)
        }
        
        let type =  self.msgItem.mtype //获得信息类型
        let width =  self.msgItem.view.frame.size.width //获得信息宽度
        let height =  self.msgItem.view.frame.size.height //获得信息高度
        
        //信息view的x，y
        var x =  (type == ChatType.Someone) ? 0 : Width-width-self.msgItem.insets.left-self.msgItem.insets.right //设置x坐标
        var y:CGFloat = 0 //设置y坐标
        
        if (self.msgItem.user.username != ""){
            
            let thisUser =  self.msgItem.user
            
            //设置用户图片
            self.avatarImage = UIImageView(image: thisUser.icon)
            self.avatarImage.layer.cornerRadius = 3.0
            self.avatarImage.layer.masksToBounds = true
            self.avatarImage.layer.borderColor = UIColor(white:0.0 ,alpha:0.2).CGColor
            self.avatarImage.layer.borderWidth = 1.0
            
            //计算用户头像的x坐标
            let avatarX =  (type == ChatType.Someone) ? 2 : Width-52 //x坐标 对方的为2 自己的为 Width-52
            let avatarY: CGFloat = 0 //y坐标为信息的高度，为了对其，设置相应值
            self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50)
            self.addSubview(self.avatarImage)
            
            //计算信息view的xy
            let delta =  self.frame.size.height - (self.msgItem.insets.top + self.msgItem.insets.bottom + height) //获取cell与整个信息高度的差
            if (delta > 0){ //cell与整个信息高度的差大于0 ， 就取这个值作为起始y
                y = delta
            }
            if (type == ChatType.Someone){
                x += 54
            }
            if (type == ChatType.Mine){
                x -= 54
            }
        }
        
        //判断气泡的类型和位置 , 图片就不显示气泡
        if(!self.msgItem.view.isKindOfClass(UIImageView)){
            self.bubbleView = BubbleItem.init(mtype: type, frame: CGRectMake(x, y, width + self.msgItem.insets.left + self.msgItem.insets.right, height + self.msgItem.insets.top + self.msgItem.insets.bottom))
            self.addSubview(self.bubbleView.view)
            //添加信息体的view
            self.customView = self.msgItem.view
        
            self.customView.frame = CGRectMake(self.msgItem.insets.left, self.msgItem.insets.top, width, height)
            self.bubbleView.view.addSubview(self.customView)
            
            self.customView.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapedText))
            self.customView.addGestureRecognizer(tap)
            
        }else{
            //添加信息体的view
            self.customView = self.msgItem.view
            self.customView.frame = CGRectMake(x+self.msgItem.insets.left, y+self.msgItem.insets.top, width, height)
            
            self.customView.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapedPic))
            self.customView.tag = 1
            self.customView.addGestureRecognizer(tap)
            self.addSubview(self.customView)
        }
    }
    
    func tapedPic(sender: UITapGestureRecognizer){
        
        let frame = sender.view?.superview?.convertRect((sender.view?.frame)!, toView: sender.view?.superview?.superview?.superview?.superview)
        
        
        let imageNameH = "H" + self.msgItem.imageName!
        var imageArray = [UIImage]()
        var imageDate = [NSDate]()
        var tag = 0 //点击的第几张图片
        var j = 0 //记录总图片数
        //读取聊天的图片数据
        let chatsData = SaveDataModel()
        let chatCacheImages = SaveCacheDataModel()
        
        let singleChatData = chatsData.loadChatsDataFromTempDirectory("\(chatName).plist", key: chatName)
        for i in 0 ..< singleChatData.count {
            if singleChatData[i].chatImage != "" {
                let imageName = "H"+singleChatData[i].chatImage+".png"
                let imageData = chatCacheImages.loadImageFromChatCacheDir(chatName, imageName: imageName)
                let image = ChangeValue.dataToImage(imageData)
                imageArray.append(image)
                imageDate.append(singleChatData[i].chatDate)
                
                if imageName == imageNameH {
                    tag = j
                }
                j += 1
            }
        }
        
        self.delegate?.showPic(imageArray, index: tag, imageDate: imageDate, frame: frame!)
    }
    
    func tapedText(){
        print("taped text")
    }
}
