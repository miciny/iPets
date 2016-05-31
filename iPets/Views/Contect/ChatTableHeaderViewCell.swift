import UIKit

//分时显示时间
class ChatTableHeaderViewCell: UITableViewCell{
    var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(reuseIdentifier cellId:String){
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
    }
    
    class func getHeight() -> CGFloat{
        return 50.0
    }
    
    func setDate(value: NSDate){
        self.backgroundColor = UIColor.clearColor()
        let cellHeight = ChatTableHeaderViewCell.getHeight()
        
        //显示格式
        let text = DateToToString.getChatTimeFormat(value)
        
        if (self.label != nil){
            self.label.text = text
            return
        }
        self.selectionStyle = UITableViewCellSelectionStyle.None
        let timeSize = sizeWithText(text, font: chatPageTimeFont, maxSize: CGSize(width: Width, height: cellHeight))
        
        let padding = CGFloat(10)
        let viewWidth = timeSize.width+padding*2
        let viewHeight = timeSize.height+padding
        let view = UIView(frame: CGRect(x: Width/2-viewWidth/2, y: (cellHeight-viewHeight)/2, width: viewWidth, height: viewHeight))
        view.backgroundColor = UIColor.lightGrayColor()
        view.layer.cornerRadius = 3
        
        self.label = UILabel(frame:CGRectMake(padding, padding/2, timeSize.width, timeSize.height))
        self.label.text = text
        self.label.font = chatPageTimeFont
        self.label.textAlignment = NSTextAlignment.Center
        self.label.textColor = UIColor.whiteColor()
        self.label.backgroundColor = UIColor.clearColor()
        
        view.addSubview(self.label)
        self.addSubview(view)
    }
}