import UIKit

enum ChatBubbleTypingType{
    case Nobody
    case Me
    case Somebody
}

class ChatTableView: UITableView, UITableViewDelegate, UITableViewDataSource{
    
    var bubbleSection: NSMutableArray! //对话体
    var chatDataSource: ChatDataSource! //chat类型的数据
    
    var snapInterval: NSTimeInterval! //时间间隔
    var typingBubble: ChatBubbleTypingType! //信息类型
    
    var chatTitle: String! //聊天的标题
    
    private let picView = SingleChatPicView() //展示图片的
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, style: UITableViewStyle, chatTitle: String) {

        self.snapInterval = 60 * 3 //时间间隔
        self.chatTitle = chatTitle
        self.typingBubble = ChatBubbleTypingType.Nobody
        self.bubbleSection = NSMutableArray()
        
        super.init(frame:frame, style:style)
        
        self.backgroundColor = UIColor.clearColor()
        self.separatorStyle = UITableViewCellSeparatorStyle.None //分割时的样式
        
        self.delegate = self
        self.dataSource = self
        
    }
    
    //按日期排序方法
    func sortDate(m1: AnyObject!, m2: AnyObject!) -> NSComparisonResult {
        if((m1 as! MessageItem).date.timeIntervalSince1970 < (m2 as! MessageItem).date.timeIntervalSince1970){
            return NSComparisonResult.OrderedAscending
        }else{
            return NSComparisonResult.OrderedDescending
        }
    }
    
    override func reloadData(){
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        self.bubbleSection = NSMutableArray()
        var count =  0
        if ((self.chatDataSource != nil)){
            count = self.chatDataSource.rowsForChatTable(self) //这种代理实现信息提取？
            if(count > 0){
                let bubbleData =  NSMutableArray(capacity:count)
                
                for i in 0 ..< count{
                    let object =  self.chatDataSource.chatTableView(self, dataForRow:i)
                    bubbleData.addObject(object)
                }
                bubbleData.sortUsingComparator(sortDate)
                
                var last =  DateToToString.stringToData("1970-01-01 12:00:00", format: "yyyy-MM-dd HH:mm:ss") //上一个消息的时间
                var currentSection = NSMutableArray()
                
                for i in 0 ..< count{
                    let data =  bubbleData[i] as! MessageItem
                    // 使用日期格式器格式化日期，日期不同，就新分组
                    let datestr = data.date
                    
                    let second = datestr.timeIntervalSinceDate(last) //获取时间差
                    if (second > snapInterval){  //分割时间的条件
                        currentSection = NSMutableArray()
                        self.bubbleSection.addObject(currentSection)
                    }
                    self.bubbleSection[self.bubbleSection.count-1].addObject(data)
                    
                    last = datestr //上一个消息的时间
                }
            }
        }
        super.reloadData()
        
        //进入页面，自动滑到最后一部分
        moveToBottom()
    }
    
    //返回到底部
    // self.scrollToRowAtIndexPath(indexPath, atScrollPosition:UITableViewScrollPosition.Bottom, animated:true) 中的atScrollPosition:UITableViewScrollPosition.Bottom不起作用，日了狗，不知道怎么处理了，只能这么干了
    //第一次进入页面
    func moveToBottomFirst(){
        let count = self.bubbleSection.count
        if(count == 0){
            return
        }
        
        let dataTmp: [AnyObject] = bubbleSection[count-1] as! [AnyObject]
        let data: AnyObject = dataTmp[dataTmp.count-1]
        let item =  data as! MessageItem
        
        let offsetY = self.contentSize.height - self.frame.size.height + 44 + item.insets.bottom
        //如果不足一屏幕，不滑动
        if(offsetY < 0){
            return
        }
        
        self.setContentOffset(CGPointMake(0, offsetY), animated: true)
    }
    
    //每次发送信息
    func moveToBottom(){
        let count = self.bubbleSection.count
        if(count == 0){
            return
        }
        
        let dataTmp: [AnyObject] = bubbleSection[count-1] as! [AnyObject]
        let data: AnyObject = dataTmp[dataTmp.count-1]
        let item =  data as! MessageItem
        
        //如果为文字消息，为了消除误差
        if item.imageName == nil {
            moveToBottomAuto()
            return
        }
        
        let offsetY = self.contentSize.height - self.frame.size.height + 44 + item.insets.bottom
        //如果不足一屏幕，不滑动
        if(offsetY < 0){
            return
        }
        
        self.setContentOffset(CGPointMake(0, offsetY), animated: true)
    }
    
    //进入页面，自动滑到最后一部分
    func moveToBottomAuto(){
        
        if(self.bubbleSection.count > 0){
            
            let secno = self.bubbleSection.count - 1
            let indexPath =  NSIndexPath(forRow:self.bubbleSection[secno].count,inSection:secno)
            
            self.scrollToRowAtIndexPath(indexPath, atScrollPosition:UITableViewScrollPosition.Bottom, animated:true)
            
        }
    }
    
    //section的行数
    func numberOfSectionsInTableView(tableView:UITableView)->Int{
        var result = self.bubbleSection.count
        if (self.typingBubble != ChatBubbleTypingType.Nobody){ //主要是时间那行
            result += 1
        }
        return result
    }
    
     //每个section的row数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (section >= self.bubbleSection.count){ //主要是时间那行
            return 1
        }
        return self.bubbleSection[section].count+1
    }
    
    //计算每行的高度
    func tableView(tableView:UITableView,heightForRowAtIndexPath  indexPath:NSIndexPath) -> CGFloat{
        // Header
        if (indexPath.row == 0){
            return ChatTableHeaderViewCell.getHeight()
        }
        let section: [AnyObject]  =  self.bubbleSection[indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row-1]
        
        let item =  data as! MessageItem
        let height  = max(item.insets.top + item.view.frame.size.height + item.insets.bottom, 50) + 10//还得加上头像超出的部分
        
        return height
    }
    
    //每行显示的内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{        
        // 头，即时间
        if (indexPath.row == 0){
            let cellId = "HeaderCell"
            let hcell =  ChatTableHeaderViewCell(reuseIdentifier: cellId)
            let section : [AnyObject]  =  self.bubbleSection[indexPath.section] as! [AnyObject]
            let data = section[indexPath.row] as! MessageItem
            
            hcell.setDate(data.date)
            return hcell
        }
        // 信息体
        let cellId = "ChatCell"
        
        let section : [AnyObject]  =  self.bubbleSection[indexPath.section] as! [AnyObject]
        let data = section[indexPath.row - 1]
        
        let cell =  ChatTableViewCell(data: data as! MessageItem, reuseIdentifier: cellId, chatName: chatTitle)
        cell.delegate = self
        return cell
    }
}

extension ChatTableView: SingleChatPicViewDelegate{
    
    func showPic(pic: [UIImage], index: Int, imageDate: [NSDate], frame: CGRect) {
        picView.setUpPic(pic, index: index, imageDate: imageDate, frame: frame)
    }
}

