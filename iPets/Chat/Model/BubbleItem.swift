import UIKit

class BubbleItem: NSObject{
    
    var bubble: UIImageView
    var mtype: ChatType
    var frame: CGRect
    var view: UIView
    var imageView: UIImageView
    
    init(mtype: ChatType, frame: CGRect, bubble: UIImageView, view: UIView, image: UIImageView){
        self.mtype = mtype
        self.frame = frame
        self.bubble = bubble
        self.view = view
        self.imageView = image
    }
    
    //我的
    convenience init(mtype: ChatType, frame: CGRect){
        let bubble = UIImageView()
        let bubbleView = UIView()
        
        //装气泡的view
        bubbleView.frame = frame
        bubbleView.backgroundColor = UIColor.clear
        
        //气泡
        bubble.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        switch mtype{
        case .someone:
            bubble.image = UIImage(named:("YouChat"))!.stretchableImage(withLeftCapWidth: 33,topCapHeight:30)
        case .mine:
            bubble.image = UIImage(named:"IChat")!.stretchableImage(withLeftCapWidth: 33, topCapHeight:30)
        }
        bubbleView.addSubview(bubble)
        
        self.init(mtype: mtype, frame: frame, bubble: bubble, view: bubbleView, image: bubble)
    }
    
}
