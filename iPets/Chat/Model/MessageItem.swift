import UIKit

enum ChatType: String{
    case mine = "1"
    case someone = "0"
}

enum MessageType: String {
    case text = "text"
    case image = "image"
    case voice = "voice"
}

protocol MessageItemDelegate {
    func lbLongPressed()  //长按了
    
    func lbNoPressed()  //取消长按
    
    func imageLongPressed()
    
    func imageNoPressed()
}

class MessageItem: NSObject, CanCopyLabelDelegate, CanCopyImageDelegate{
    var user: UserInfo
    var date: Date
    var mtype: ChatType
    var view: UIView
    var insets: UIEdgeInsets
    
    var imageName: String?  //图片消息
    
    var voicePath: String?  //语音消息
    var voiceLong: String?     //语音时长
    
    var messageType: MessageType   //消息类型
    var delegate: MessageItemDelegate?
    
    //图片和文字与周围的间距
    class func getTextInsetsMine() -> UIEdgeInsets{
        return UIEdgeInsets(top:15, left:15, bottom:25, right:20)
    }
    
    class func getTextInsetsSomeone() -> UIEdgeInsets{
        return UIEdgeInsets(top:15, left:20, bottom:25, right:15)
    }
    
    class func getImageInsetsMine() -> UIEdgeInsets{
        return UIEdgeInsets(top:0, left:0, bottom:20, right:15)
    }
    
    class func getImageInsetsSomeone() -> UIEdgeInsets{
        return UIEdgeInsets(top:0, left:15, bottom:20, right:0)
    }
    
    //初始化
    init(user: UserInfo, date: Date, mtype: ChatType, view: UIView,
         insets: UIEdgeInsets, imageName: String?, voicePath: String?, voiceLong: String?, messageType: MessageType){
        self.view = view
        self.user = user
        self.date = date
        self.mtype = mtype
        self.insets = insets
        self.voicePath = voicePath
        self.imageName = imageName
        self.messageType = messageType
        self.voiceLong = voiceLong
    }
    
    //文字类型消息
    convenience init(body: String, user: UserInfo, date: Date, mtype: ChatType){
        let width =  Width-104-MessageItem.getTextInsetsMine().left-MessageItem.getTextInsetsMine().right
        let height : CGFloat = 10000.0
        let size =  sizeWithText(body as String, font: chatPageTextFont, maxSize: CGSize(width: width, height: height))
        
        let label =  CanCopyLabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.canCopyLabelFrom = CanCopyLabelFrom.chat
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = body
        label.font = chatPageTextFont
        label.backgroundColor = UIColor.clear
        
        let insets: UIEdgeInsets = (mtype == ChatType.mine ? MessageItem.getTextInsetsMine() : MessageItem.getTextInsetsSomeone())
        
        self.init(user: user, date: date, mtype: mtype, view: label, insets: insets,
                  imageName: nil, voicePath: nil, voiceLong: nil, messageType: .text)
        
        label.copyLabelDelegate = self
    }
    
    //文字长按事件
    func lbLongPressed() {
        self.delegate?.lbLongPressed()
    }
    //文字取消长按事件
    func lbNoPressed() {
        self.delegate?.lbNoPressed()
    }
    
    
    
    
    
    //图片类型消息
    convenience init(image: UIImage, imageName: String, user: UserInfo, date: Date, mtype: ChatType){
        var size = image.size
        //等比缩放
        if (size.width > 170){
            size.height /= (size.width / 170)
            size.width = 170
        }
        
        let imageView = CanCopyImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        imageView.image = image
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        
        let insets:UIEdgeInsets =  (mtype == ChatType.mine ? MessageItem.getImageInsetsMine() : MessageItem.getImageInsetsSomeone())
        
        self.init(user: user, date: date, mtype: mtype, view: imageView,
                  insets: insets, imageName: imageName, voicePath: nil, voiceLong: nil, messageType: .image)
    }
    
    //图片长按
    func imageLongPressed() {
        self.delegate?.imageLongPressed()
    }
    
    func imageNoPressed() {
        self.delegate?.imageNoPressed()
    }
    
    
    
    
    //语音类型消息
    convenience init(voicePath: String, voiceLong: String, user: UserInfo, date: Date, mtype: ChatType){
        
        let long = CGFloat(Int(voiceLong)!)
        let width =  Width-104-MessageItem.getTextInsetsMine().left-MessageItem.getTextInsetsMine().right
        
        var vW = CGFloat()
        
        if long < 5{
            vW = 1/8 * width
        }else if long > 60 {
            vW = width
        }else{
            vW = (long-5)/55 * (7*width/8) + 1/8 * width
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: vW, height: 20))
        
        let btn =  UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let btnB =  CanCopyLabel(frame: CGRect(x: 0, y: 0, width: vW, height: 20))
        btnB.canCopyLabelFrom = CanCopyLabelFrom.chat
        let image = UIImage(named: "SenderVoiceNodePlaying")
        btn.image = image
        
        view.addSubview(btn)
        view.addSubview(btnB)
        
        let insets: UIEdgeInsets = (mtype == ChatType.mine ? MessageItem.getTextInsetsMine() : MessageItem.getTextInsetsSomeone())
        
        self.init(user:user, date: date, mtype: mtype, view: view,
                  insets: insets, imageName: nil, voicePath: voicePath, voiceLong: voiceLong, messageType: .voice)
    }
    
}
