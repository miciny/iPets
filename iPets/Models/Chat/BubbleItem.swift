import UIKit

class BubbleItem: NSObject{
    
    var bubble:UIImageView
    var mtype:ChatType
    var frame:CGRect
    var view:UIView
    
    init(mtype: ChatType, frame: CGRect, bubble: UIImageView, view: UIView){
        self.mtype = mtype
        self.frame = frame
        self.bubble = bubble
        self.view = view
    }
    
    //我的
    convenience init(mtype: ChatType, frame: CGRect){
        let bubble = UIImageView()
        let bubbleView = UIView()
        //装气泡的view
        bubbleView.frame = frame
        bubbleView.backgroundColor = UIColor.clearColor()
        
        //气泡
        bubble.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        switch mtype{
        case .Someone:
            bubble.image = UIImage(named:("YouChat"))!.stretchableImageWithLeftCapWidth(33,topCapHeight:30)
        case .Mine:
            bubble.image = UIImage(named:"IChat")!.stretchableImageWithLeftCapWidth(33, topCapHeight:30)
        }
        bubbleView.addSubview(bubble)
        
        self.init(mtype: mtype, frame: frame, bubble: bubble, view: bubbleView)
    }
    
}
