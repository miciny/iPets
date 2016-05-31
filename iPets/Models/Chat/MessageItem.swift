import UIKit

enum ChatType{
    case Mine
    case Someone
}

class MessageItem: NSObject{
    var user: UserInfo
    var date: NSDate
    var mtype: ChatType
    var view: UIView
    var insets: UIEdgeInsets
    var imageName: String?
    
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
    init(user: UserInfo, date: NSDate, mtype: ChatType, view: UIView, insets: UIEdgeInsets, imageName: String?){
        self.view = view
        self.user = user
        self.date = date
        self.mtype = mtype
        self.insets = insets
        self.imageName = imageName
    }
    
    //文字类型消息
    convenience init(body: NSString, user: UserInfo, date: NSDate, mtype: ChatType){
        let width =  Width-104-MessageItem.getTextInsetsMine().left-MessageItem.getTextInsetsMine().right
        let height : CGFloat = 10000.0
        let size =  sizeWithText(body, font: chatPageTextFont, maxSize: CGSizeMake(width, height))
        
        let label =  UILabel(frame:CGRectMake(0, 0, size.width, size.height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.text = (body.length != 0 ? body as String : "")
        label.font = chatPageTextFont
        label.backgroundColor = UIColor.clearColor()
        
        let insets: UIEdgeInsets = (mtype == ChatType.Mine ? MessageItem.getTextInsetsMine() : MessageItem.getTextInsetsSomeone())
        
        self.init(user:user, date:date, mtype:mtype, view:label, insets:insets, imageName: nil)
    }    
    
    //图片类型消息
    convenience init(image: UIImage, imageName: String, user: UserInfo, date: NSDate, mtype: ChatType){
        var size = image.size
        //等比缩放
        if (size.width > 170){
            size.height /= (size.width / 170)
            size.width = 170
        }
        
        let imageView = UIImageView(frame:CGRectMake(0, 0, size.width, size.height))
        imageView.image = image
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        
        let insets:UIEdgeInsets =  (mtype == ChatType.Mine ? MessageItem.getImageInsetsMine() : MessageItem.getImageInsetsSomeone())
        
        self.init(user:user, date:date, mtype:mtype, view:imageView, insets:insets, imageName: imageName)
    }
    
}