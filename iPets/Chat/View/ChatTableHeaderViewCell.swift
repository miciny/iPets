import UIKit

//分时显示时间
class ChatTableHeaderViewCell: UITableViewCell{
    var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(reuseIdentifier cellId:String){
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
    }
    
    class func getHeight() -> CGFloat{
        return 50.0
    }
    
    func setDate(_ value: Date){
        self.backgroundColor = UIColor.clear
        let cellHeight = ChatTableHeaderViewCell.getHeight()
        
        //显示格式
        let text = DateToToString.getChatTimeFormat(value)
        
        if (self.label != nil){
            self.label.text = text
            return
        }
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        let timeSize = sizeWithText(text, font: chatPageTimeFont, maxSize: CGSize(width: Width, height: cellHeight))
        
        let padding = CGFloat(10)
        let viewWidth = timeSize.width+padding*2
        let viewHeight = timeSize.height+padding
        let view = UIView(frame: CGRect(x: Width/2-viewWidth/2, y: (cellHeight-viewHeight)/2, width: viewWidth, height: viewHeight))
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 3
        
        self.label = UILabel(frame:CGRect(x: padding, y: padding/2, width: timeSize.width, height: timeSize.height))
        self.label.text = text
        self.label.font = chatPageTimeFont
        self.label.textAlignment = NSTextAlignment.center
        self.label.textColor = UIColor.white
        self.label.backgroundColor = UIColor.clear
        
        view.addSubview(self.label)
        self.addSubview(view)
    }
}
