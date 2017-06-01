import UIKit

enum ChatType: String{
    case mine = "1"
    case someone = "0"
}

class MessageItem: NSObject{
    var user: UserInfo
    var date: Date
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
    init(user: UserInfo, date: Date, mtype: ChatType, view: UIView, insets: UIEdgeInsets, imageName: String?){
        self.view = view
        self.user = user
        self.date = date
        self.mtype = mtype
        self.insets = insets
        self.imageName = imageName
    }
    
    //文字类型消息
    convenience init(body: NSString, user: UserInfo, date: Date, mtype: ChatType){
        let width =  Width-104-MessageItem.getTextInsetsMine().left-MessageItem.getTextInsetsMine().right
        let height : CGFloat = 10000.0
        let size =  sizeWithText(body as String, font: chatPageTextFont, maxSize: CGSize(width: width, height: height))
        
        let label =  UILabel(frame:CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = (body.length != 0 ? body as String : "")
        label.font = chatPageTextFont
        label.backgroundColor = UIColor.clear
        
        let insets: UIEdgeInsets = (mtype == ChatType.mine ? MessageItem.getTextInsetsMine() : MessageItem.getTextInsetsSomeone())
        
        self.init(user:user, date:date, mtype:mtype, view:label, insets:insets, imageName: nil)
    }    
    
    //图片类型消息
    convenience init(image: UIImage, imageName: String, user: UserInfo, date: Date, mtype: ChatType){
        var size = image.size
        //等比缩放
        if (size.width > 170){
            size.height /= (size.width / 170)
            size.width = 170
        }
        
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: size.width, height: size.height))
        imageView.image = image
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        
        let insets:UIEdgeInsets =  (mtype == ChatType.mine ? MessageItem.getImageInsetsMine() : MessageItem.getImageInsetsSomeone())
        
        self.init(user:user, date:date, mtype:mtype, view:imageView, insets:insets, imageName: imageName)
    }
    
}
