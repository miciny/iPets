//
//  ChatViewController.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/16.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import AssetsLibrary

class ChatViewController: UIViewController, ChatDataSource, UITextViewDelegate, PassPhotosDelegate{
    
    private var Chats: NSMutableArray!  //用于显示的数据
    private var tableView: ChatTableView!
    private var txtMsg: UITextView!
    private var txtMsgView: UIView!
    private let sendView = UIView() //
    private var chatDataArray: [ChatData]?  //保存原来的数据,添加新的数据用于保存
    
    private var time: NSDate?//保存最后一条消息的时间
    private var lable: String? //保存最后一条消息
    private var isChanged = false //是否发生过信息
    private var tap = UITapGestureRecognizer() //键盘弹起时，注册该方法, 方便收起键盘
    
    //17.895
    private var singgleLineSize = CGSize()
    private var gap = CGFloat()

    var youInfo:  UserInfo! //传入对方信息
    private var yourNickname: String!
    private var isOut = true //如果是进入的选择图片界面，就置成false，就不删除数据库了
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Chats = NSMutableArray()
        chatDataArray = [ChatData]()
        
        initData()
        
        setupChatTable()
        setupSendPanel()
        
        self.tableView.moveToBottomFirst()
    }
    
    //退出时保存数据
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{
            //这里写需要放到子线程做的耗时的代码
            
            self.saveChatData()
            self.saveChatList()
            
            dispatch_async(dispatch_get_main_queue(), {
                print("saved")
            })
        })
    }
    
//＊＊＊＊＊＊＊＊＊＊＊＊初始化页面＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //底部发送栏
    func setupSendPanel(){
        self.title = youInfo.username //获取标题
        self.view.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
    
        sendView.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44) //底部发送框
        sendView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        sendView.alpha = 0.9
        
        //消息输入框
        txtMsgView = UIView(frame: CGRectMake(36, 4, sendView.frame.width-120, 36))
        txtMsgView.backgroundColor = UIColor.whiteColor()
        txtMsgView.layer.cornerRadius = 7
        sendView.addSubview(txtMsgView)
        
        txtMsg = UITextView(frame:CGRectMake(0, 0, 0, 0))
        txtMsg.backgroundColor = UIColor.clearColor()
        txtMsg.textColor = UIColor.blackColor()
        txtMsg.font = chatPageInputTextFont
        txtMsg.selectable = true //可选
        txtMsg.editable=true //可编辑
        txtMsg.layoutManager.allowsNonContiguousLayout = false //防止光标跳动
        txtMsg.returnKeyType = UIReturnKeyType.Send
        txtMsg.delegate = self
        txtMsgView.addSubview(txtMsg)
        
        singgleLineSize = txtMsg.sizeThatFits(CGSizeMake(CGRectGetWidth(txtMsg.frame), CGFloat(MAXFLOAT)))
        gap = (CGFloat(36) - singgleLineSize.height)/2
        txtMsg.frame = CGRectMake(5, gap, sendView.frame.width-130, singgleLineSize.height)
        
        //左侧声音图片
        let voiceButton = UIImageView(frame:CGRectMake(4, 8, 28, 28))
        voiceButton.backgroundColor=UIColor.clearColor()
        voiceButton.image = UIImage(named: "Sound")
        sendView.addSubview(voiceButton)
        
        // 右边＋按钮
        let addButton = UIImageView(frame:CGRectMake(sendView.frame.width-80, 4, 36, 36))
        addButton.backgroundColor=UIColor.clearColor()
        addButton.image = UIImage(named: "AddMoreFuns")
        
        addButton.userInteractionEnabled = true
        let addTap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.goToImageCollectionView))
        addButton.addGestureRecognizer(addTap)
        sendView.addSubview(addButton)
        
        //右边表情按钮
        let emotionButton = UIImageView(frame:CGRectMake(Width-40, 4, 36, 36))
        emotionButton.backgroundColor=UIColor.clearColor()
        emotionButton.image = UIImage(named: "Emotion")
        
        emotionButton.userInteractionEnabled = true
        let motionTap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.motionAdd))
        emotionButton.addGestureRecognizer(motionTap)
        sendView.addSubview(emotionButton)
        
        self.view.addSubview(sendView)
    }
    
    //选择表情
    func motionAdd(){
        print("ok")
        
    }
    
    //进入选择图片页面
    func goToImageCollectionView(){
        isOut = false
        
        let imagePickVc = ImageCollectionViewController()
        imagePickVc.photoDelegate = self  //经常忘记这一步
        imagePickVc.pageTitle = "发送"
        imagePickVc.countLimited = 10
        self.navigationController?.pushViewController(imagePickVc, animated: true)
    }
    
    //选择图片界面的代理方法
    func passPhotos(selected: [ImageCollectionModel]) {
        var timeArray = [NSDate]()
        var timestrArray = [String]()
        var picArray = [UIImage]()
        
        for i in 0 ..< selected.count {
            //image的名字
            let timeDate = NSDate()
            let timeStr = DateToToString.dateToStringBySelf(timeDate, format: "yyyyMMddHHmmss\(i)")
            
            //先显示全屏图
            let image = UIImage(CGImage: selected[i].asset.aspectRatioThumbnail().takeRetainedValue())
            sendPic(image, imageName: timeStr+".png")
            
            timeArray.append(timeDate)
            timestrArray.append(timeStr)
            picArray.append(image)
            
            time = timeDate
            lable = "[图片]"
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{
            //保存图片 , 高清图
            let saveCache = SaveCacheDataModel()
            
            for j in 0 ..< selected.count{
                let representation =  selected[j].asset.defaultRepresentation()
                let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
                let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
                    length: Int(representation.size()), error: nil)
                let data = NSData(bytesNoCopy: imageBuffer ,length: bufferSize, freeWhenDone: true)

                //保存图片到本地沙盒
                saveCache.savaImageToChatCacheDir(self.yourNickname, image: picArray[j], imageName: timestrArray[j], imageType: "png")
                saveCache.savaImageToChatCacheDir(self.yourNickname, imageData: data, imageName: "H"+timestrArray[j]+".png")
                
                let sendedImage = ChatData(chatType: 1, chatBody: "", time: timeArray[j], chatImage: timestrArray[j])
                self.chatDataArray?.append(sendedImage)
            }
            dispatch_async(dispatch_get_main_queue(), {
                print("saved Pic")
                self.saveChatData()
            })
        })
    }
    
    //发送图片
    func sendPic(image: UIImage, imageName: String){
        
        let thisChat =  MessageItem(image: image, imageName: imageName, user: myInfo, date: NSDate(), mtype: ChatType.Mine)
        self.Chats.addObject(thisChat)
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        isChanged = true
        isOut = true
    }
    
//＊＊＊＊＊＊＊＊＊＊＊＊发送和接受消息＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //发送信息
    func sendMessage(){
        let time1 = NSDate()
        time = NSDate()
        //去掉首位空格和换行符
        let msg = txtMsg.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//        whitespaceAndNewlineCharacterSet
        if msg == ""{
            ToastView().showToast("不能为空")
            txtMsg.resignFirstResponder()
            return
        }
        
        //MessageItem格式的 就可以展示了
        let thisChat =  MessageItem(body: msg, user: myInfo, date: time1, mtype: ChatType.Mine)
        let thatChat =  MessageItem(body: "你说的是：\(msg)", user: youInfo, date: self.time!, mtype: ChatType.Someone)
        Chats.addObject(thisChat)
        Chats.addObject(thatChat)
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        lable = "你说的是：\(msg)"
        isChanged = true
        txtMsg.text = ""
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{
            
            //同步保存数据
            let first1 = ChatData(chatType: 1, chatBody: msg, time: time1, chatImage: "")
            let first2 = ChatData(chatType: 0, chatBody: "你说的是：\(msg)", time: self.time!, chatImage: "")
            self.chatDataArray?.append(first1)
            self.chatDataArray?.append(first2)
            
            dispatch_async(dispatch_get_main_queue(), {
                print("saved Msg")
            })
        })
        saveChatData()
    }
    
//＊＊＊＊＊＊＊＊＊＊＊＊键盘相关代理＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    
    //键盘的return键
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let offset: CGFloat = self.view.frame.size.height - 266
        
        //发送按钮 ， 发送直接返回
        if (text == "\n"){
            sendMessage()
            return true
        }
        
        //获得新的字符串
        let newText = textView.text!.stringByReplacingCharactersInRange(
            range.toRange(textView.text!), withString: text)
//        print(newText)
        
        let textViewSize = sizeWithText(newText, font: chatPageInputTextFont, maxSize: CGSize(width: sendView.frame.width-130, height: 1000))
        let singgleLineSize1 = sizeWithText("我爱你！", font: chatPageInputTextFont, maxSize: CGSize(width: sendView.frame.width-130, height: 1000))
        //获取行数，可能不是很准
        let i = textViewSize.height/singgleLineSize1.height
//        print(i)
//        let size = txtMsg.sizeThatFits(CGSizeMake(CGRectGetWidth(txtMsg.frame), CGFloat(MAXFLOAT)))
        if(i < 5){
            //底部发送框
            let sendViewHeight = singgleLineSize1.height*(i-1)+8+gap*2+singgleLineSize.height
            sendView.frame = CGRectMake(0, offset-sendViewHeight, self.view.frame.size.width, sendViewHeight)
            //消息输入框
            txtMsgView.frame = CGRectMake(36, 4, sendView.frame.width-120, singgleLineSize1.height*(i-1)+gap*2+singgleLineSize.height)
            txtMsg.frame = CGRectMake(5, gap, sendView.frame.width-130, singgleLineSize1.height*(i-1)+singgleLineSize.height)
            
            //防止跳动
            txtMsg.scrollRangeToVisible(NSMakeRange(0, 0))
            
        }else{
            //底部发送框
            let sendViewHeight = singgleLineSize1.height*4+8+gap*2+singgleLineSize.height
            sendView.frame = CGRectMake(0, offset-sendViewHeight, self.view.frame.size.width, sendViewHeight)
            //消息输入框
            txtMsgView.frame = CGRectMake(36, 4, sendView.frame.width-120, singgleLineSize1.height*4+gap*2+singgleLineSize.height)
            txtMsg.frame = CGRectMake(5, gap, sendView.frame.width-130, singgleLineSize1.height*4+singgleLineSize.height)
        }
        return true
    }
    
    //
    func textViewDidChange(textView: UITextView) {
        
        if(textView.text == "\n"){
            textView.text = ""
            let offset: CGFloat = self.view.frame.size.height - 266
            //底部发送框
            let sendViewHeight = 8+gap*2+singgleLineSize.height
            sendView.frame = CGRectMake(0, offset-sendViewHeight, self.view.frame.size.width, sendViewHeight)
            //消息输入框
            txtMsgView.frame = CGRectMake(36, 4, sendView.frame.width-120, gap*2+singgleLineSize.height)
            txtMsg.frame = CGRectMake(5, gap, sendView.frame.width-130, singgleLineSize.height)
        }
        
    }

    //弹起输入框
    func textViewDidBeginEditing(textView: UITextView) {
        let offset: CGFloat = self.view.frame.size.height - 266
        
        if offset > 0 {
            //弹起tableView和输入框
            let frame = sendView.frame
            tableView.frame = CGRectMake(0, 0, self.view.frame.width, offset-44)
            sendView.frame = CGRectMake(0, offset-frame.height, self.view.frame.size.width, frame.height)
            tableView.moveToBottomAuto()
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.handleTap(_:)))
        tableView.addGestureRecognizer(tap)
    }
    
    //收起键盘
    func handleTap(sender: UITapGestureRecognizer) {
        if(sender.state == .Ended) {
            txtMsg.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    //结束编辑时，
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        tableView.removeGestureRecognizer(tap)
        return true
    }
    
    //收起键盘时，移动整个页面
    func textViewDidEndEditing(textView: UITextView) {
        
        delay(0.1){
            //收回tableView和输入框
            
            let frame = self.sendView.frame
            self.sendView.frame = CGRectMake(0, self.view.frame.size.height-frame.height, self.view.frame.size.width, frame.height)
            self.tableView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.size.height-self.sendView.frame.height)
            self.tableView.moveToBottomAuto()
        }
    }
    
    
//＊＊＊＊＊＊＊＊＊＊＊＊初始化数据和存储数据＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //初始化数据
    func initData(){
        
        myInfo = UserInfo(name: myInfo.username ,icon: myInfo.icon, nickname: myInfo.nickname)
        yourNickname = youInfo.nickname! as String
        isOut = true
        
        //读取数据
        let chatsData = SaveDataModel() //保存聊天记录的方法
        let chatData = chatsData.loadChatsDataFromTempDirectory("\(yourNickname).plist", key: yourNickname)
        //先把原来的数据保存起来
        chatDataArray = chatData
        
         //读取聊天的图片数据
        let chatCacheImages = SaveCacheDataModel()
        
        for i in 0 ..< chatData.count {
            switch chatData[i].chatType {
                //0 代表对方信息
            case 0:
                if chatData[i].chatImage == "" {
                    let mesy = MessageItem(body: chatData[i].chatBody, user: youInfo,  date: chatData[i].chatDate, mtype:ChatType.Someone)
                    Chats.addObject(mesy)
                }else{
                    let imageData = chatCacheImages.loadImageFromChatCacheDir(yourNickname, imageName: chatData[i].chatImage+".png")
                    let image = ChangeValue.dataToImage(imageData)
                    
                    let mesy = MessageItem(image: image, imageName: chatData[i].chatImage+".png", user: youInfo, date: chatData[i].chatDate, mtype: ChatType.Someone )
                    Chats.addObject(mesy)
                }
                //1代表我的信息
            case 1:
                if chatData[i].chatImage == "" {
                    let mesy = MessageItem(body: chatData[i].chatBody, user: myInfo,  date: chatData[i].chatDate, mtype:ChatType.Mine)
                    Chats.addObject(mesy)
                }else{
                    let imageData = chatCacheImages.loadImageFromChatCacheDir(yourNickname, imageName: chatData[i].chatImage+".png")
                    let image = ChangeValue.dataToImage(imageData)
                    
                    let mesy = MessageItem(image: image, imageName: chatData[i].chatImage+".png" ,user: myInfo, date: chatData[i].chatDate, mtype: ChatType.Mine)
                    Chats.addObject(mesy)
                }
                
            default:
                break
            }
        }
    }
    
    //保存plist
    func saveChatData(){
        //如果是进入选择图片的界面，isOut为fasle 就直接返回了，不保存了
        if !isOut{
            return
        }
        
        //如果没有消息，就删除它，同时删除plist文件
        let chatsData = SaveDataModel() //保存聊天记录的方法
        if(chatDataArray?.count == 0){
            chatsData.deleteChatsPListFile("\(yourNickname).plist") //删除plist文件
            return
        }
        chatsData.saveChatsToTempDirectory(chatDataArray! ,fileName: "\(yourNickname).plist", key: yourNickname) //保存时，以对方名字命名，如果名字不一样就不会出错了
//        print("saveChatData")
    }
    
    //同步数据到chatlist
    func saveChatList() {
        //如果是进入选择图片的界面，isOut为fasle 就直接返回了，不保存了
        if !isOut {
            return
        }
        
        let chatList = SQLLine.SelectAllData(entityNameOfChatList)
        
        //没消息就删数据库
        if(chatDataArray!.count == 0){
            for i in 0 ..< chatList.count {
                let title = chatList[i].valueForKey(ChatListNameOfNickname) as! String
                if(title == yourNickname){
                    SQLLine.DeleteData(entityNameOfChatList, indexPath: i)
                    break
                }
            }
        }
        
        //如果没发送过，就不保存
        if(!isChanged){
            return
        }
        
        //有消息就写到数据库
        for i in 0 ..< chatList.count {
            let title = chatList[i].valueForKey(ChatListNameOfNickname) as! String
            if(title == yourNickname){
                SQLLine.UpdateChatListData(i, changeValue: time!, changeEntityName: ChatListNameOfTime)
                SQLLine.UpdateChatListData(i, changeValue: lable! as String, changeEntityName: ChatListNameOfLable)
                break
            }
        }
    }
    
//＊＊＊＊＊＊＊＊＊＊＊＊tableView初始化及代理＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //设置tableView
    func setupChatTable(){
        self.tableView = ChatTableView(frame:CGRectMake(0, 0, self.view.frame.width, self.view.frame.height-44), style: .Plain, chatTitle: self.yourNickname)
        //创建一个重用的单元格
        self.tableView!.registerClass(ChatTableViewCell.self, forCellReuseIdentifier: "ChatCell")
        self.view.addSubview(self.tableView)
        
        //set the chatDataSource
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
    }
    
    //行数
    func rowsForChatTable(tableView: ChatTableView) -> Int{
        return self.Chats.count
    }
    
    //返回模型数据
    func chatTableView(tableView: ChatTableView, dataForRow row:Int) -> MessageItem{
        return Chats[row] as! MessageItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

