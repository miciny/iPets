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
    
    var youInfo:  UserInfo! //传入对方信息
    
    fileprivate var Chats: NSMutableArray!  //用于显示的数据
    fileprivate var tableView: ChatTableView!
    fileprivate var txtMsg: UITextView!
    fileprivate var txtMsgView: UIView!
    fileprivate let sendView = UIView() //
    fileprivate var chatDataArray: [ChatData]?  //保存原来的数据,添加新的数据用于保存
    
    fileprivate var time: Date?//保存最后一条消息的时间
    fileprivate var lable: String? //保存最后一条消息
    fileprivate var isChanged = false //是否发生过信息
    fileprivate var tap = UITapGestureRecognizer() //键盘弹起时，注册该方法, 方便收起键盘
    
    //17.895
    fileprivate var singgleLineSize = CGSize()
    fileprivate var gap = CGFloat()
    fileprivate var yourNickname: String!
    fileprivate var isOut = true //如果是进入的选择图片界面，就置成false，就不删除数据库了
    
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        globalQueue.async(execute: {
            //这里写需要放到子线程做的耗时的代码
            
            self.saveChatData()
            self.saveChatList()
            
            mainQueue.async(execute: {
                print("saved")
            })
        })
    }
    
//＊＊＊＊＊＊＊＊＊＊＊＊初始化页面＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //底部发送栏
    func setupSendPanel(){
        self.title = youInfo.username //获取标题
        self.view.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
    
        sendView.frame = CGRect(x: 0, y: self.view.frame.size.height-44, width: self.view.frame.size.width, height: 44) //底部发送框
        sendView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        sendView.alpha = 0.9
        
        //消息输入框
        txtMsgView = UIView(frame: CGRect(x: 36, y: 4, width: sendView.frame.width-120, height: 36))
        txtMsgView.backgroundColor = UIColor.white
        txtMsgView.layer.cornerRadius = 7
        sendView.addSubview(txtMsgView)
        
        txtMsg = UITextView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        txtMsg.backgroundColor = UIColor.clear
        txtMsg.textColor = UIColor.black
        txtMsg.font = chatPageInputTextFont
        txtMsg.isSelectable = true //可选
        txtMsg.isEditable=true //可编辑
        txtMsg.layoutManager.allowsNonContiguousLayout = false //防止光标跳动
        txtMsg.returnKeyType = UIReturnKeyType.send
        txtMsg.delegate = self
        txtMsgView.addSubview(txtMsg)
        
        singgleLineSize = txtMsg.sizeThatFits(CGSize(width: txtMsg.frame.width, height: CGFloat(MAXFLOAT)))
        gap = (CGFloat(36) - singgleLineSize.height)/2
        txtMsg.frame = CGRect(x: 5, y: gap, width: sendView.frame.width-130, height: singgleLineSize.height)
        
        //左侧声音图片
        let voiceButton = UIImageView(frame:CGRect(x: 4, y: 8, width: 28, height: 28))
        voiceButton.backgroundColor=UIColor.clear
        voiceButton.image = UIImage(named: "Sound")
        sendView.addSubview(voiceButton)
        
        // 右边＋按钮
        let addButton = UIImageView(frame:CGRect(x: sendView.frame.width-80, y: 4, width: 36, height: 36))
        addButton.backgroundColor=UIColor.clear
        addButton.image = UIImage(named: "AddMoreFuns")
        
        addButton.isUserInteractionEnabled = true
        let addTap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.goToImageCollectionView))
        addButton.addGestureRecognizer(addTap)
        sendView.addSubview(addButton)
        
        //右边表情按钮
        let emotionButton = UIImageView(frame:CGRect(x: Width-40, y: 4, width: 36, height: 36))
        emotionButton.backgroundColor=UIColor.clear
        emotionButton.image = UIImage(named: "Emotion")
        
        emotionButton.isUserInteractionEnabled = true
        let motionTap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.motionAdd))
        emotionButton.addGestureRecognizer(motionTap)
        sendView.addSubview(emotionButton)
        
        self.view.addSubview(sendView)
    }
    
    //选择表情
    func motionAdd(){
        print("ok")
        
    }
    
//============================================发送和接受图片消息＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
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
    func passPhotos(_ selected: [ImageCollectionModel]) {
        var timeArray = [Date]()
        var timestrArray = [String]()
        var picArray = [UIImage]()
        
        for i in 0 ..< selected.count {
            //image的名字
            let timeDate = Date()
            let timeStr = DateToToString.dateToStringBySelf(timeDate, format: "yyyyMMddHHmmss\(i)")
            
            //先显示全屏图
            getBigThumbnailImage(asset: selected[i].asset, imageResult: { (image) in
                self.sendPic(image, imageName: timeStr, sendDate: timeDate)
                picArray.append(image)
            })
            
            timeArray.append(timeDate)
            timestrArray.append(timeStr)
            
            time = timeDate
            lable = "[图片]"
        }
        
        globalQueue.async(execute: {
            //保存图片 , 高清图
            let saveCache = SaveCacheDataModel()
            
            for j in 0 ..< selected.count{
                if saveCache.savaImageToChatCacheDir(self.yourNickname, image: picArray[j], imageName: timestrArray[j]){
                    print("保存普清图缓存成功！")
                }else{
                    print("保存普清图缓存失败！")
                }
                
                getRetainImage(asset: selected[j].asset, imageResult: { (image) in
                    if saveCache.savaImageToChatCacheDir(self.yourNickname, image: image, imageName: "H"+timestrArray[j]){
                        print("保存高清图缓存成功！")
                    }else{
                        print("保存高清图缓存失败！")
                    }
                })
                
                let sendedImage = ChatData(chatType: ChatType.mine.rawValue, chatBody: "", time: timeArray[j], chatImage: timestrArray[j])
                
                self.chatDataArray?.append(sendedImage)
            }
            
            mainQueue.async(execute: {          
                self.saveChatData()
            })
        })
    }
    
    //发送图片
    func sendPic(_ image: UIImage, imageName: String, sendDate: Date){
        
        let thisChat = MessageItem(image: image, imageName: imageName, user: myInfo, date: sendDate, mtype: ChatType.mine)
        let thatChat = MessageItem(image: image, imageName: imageName, user: youInfo, date: sendDate.addingTimeInterval(0.01), mtype: ChatType.someone)
        self.Chats.add(thisChat)
        self.Chats.add(thatChat)
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        isChanged = true
        isOut = true
    }
    
//============================================发送和接受文字消息＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //发送信息
    func sendMessage(){
        let time1 = Date().addingTimeInterval(-0.01)
        self.time = Date()
        //去掉首位空格和换行符
        let msg = txtMsg.text!.trimmingCharacters(in: CharacterSet.whitespaces)
//        whitespaceAndNewlineCharacterSet
        if msg == ""{
            ToastView().showToast("不能为空")
            txtMsg.resignFirstResponder()
            return
        }
        
        //MessageItem格式的 就可以展示了
        let thisChat = MessageItem(body: msg as NSString, user: myInfo, date: time1, mtype: ChatType.mine)
        let thatChat = MessageItem(body: "你说的是：\(msg)" as NSString, user: youInfo, date: self.time!, mtype: ChatType.someone)
        Chats.add(thisChat)
        Chats.add(thatChat)
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        lable = "你说的是：\(msg)"
        isChanged = true
        txtMsg.text = ""
        
        globalQueue.async(execute: {
            
            //同步保存数据
            let first1 = ChatData(chatType: ChatType.mine.rawValue, chatBody: msg, time: time1, chatImage: "")
            let first2 = ChatData(chatType: ChatType.someone.rawValue, chatBody: "你说的是：\(msg)", time: self.time!, chatImage: "")
            self.chatDataArray?.append(first1)
            self.chatDataArray?.append(first2)
            
            mainQueue.async(execute: {
                print("saved Msg")
            })
        })
        saveChatData()
    }
    
//＊＊＊＊＊＊＊＊＊＊＊＊键盘相关代理＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    
    //键盘的return键
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let offset: CGFloat = self.view.frame.size.height - 266
        
        //发送按钮 ， 发送直接返回
        if (text == "\n"){
            sendMessage()
            return true
        }
        
        //获得新的字符串
        let newText = textView.text!.replacingCharacters(
            in: range.toRange(string: textView.text!), with: text)
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
            sendView.frame = CGRect(x: 0, y: offset-sendViewHeight, width: self.view.frame.size.width, height: sendViewHeight)
            //消息输入框
            txtMsgView.frame = CGRect(x: 36, y: 4, width: sendView.frame.width-120, height: singgleLineSize1.height*(i-1)+gap*2+singgleLineSize.height)
            txtMsg.frame = CGRect(x: 5, y: gap, width: sendView.frame.width-130, height: singgleLineSize1.height*(i-1)+singgleLineSize.height)
            
            //防止跳动
            txtMsg.scrollRangeToVisible(NSMakeRange(0, 0))
            
        }else{
            //底部发送框
            let sendViewHeight = singgleLineSize1.height*4+8+gap*2+singgleLineSize.height
            sendView.frame = CGRect(x: 0, y: offset-sendViewHeight, width: self.view.frame.size.width, height: sendViewHeight)
            //消息输入框
            txtMsgView.frame = CGRect(x: 36, y: 4, width: sendView.frame.width-120, height: singgleLineSize1.height*4+gap*2+singgleLineSize.height)
            txtMsg.frame = CGRect(x: 5, y: gap, width: sendView.frame.width-130, height: singgleLineSize1.height*4+singgleLineSize.height)
        }
        return true
    }
    
    //
    func textViewDidChange(_ textView: UITextView) {
        
        if(textView.text == "\n"){
            textView.text = ""
            let offset: CGFloat = self.view.frame.size.height - 266
            //底部发送框
            let sendViewHeight = 8+gap*2+singgleLineSize.height
            sendView.frame = CGRect(x: 0, y: offset-sendViewHeight, width: self.view.frame.size.width, height: sendViewHeight)
            //消息输入框
            txtMsgView.frame = CGRect(x: 36, y: 4, width: sendView.frame.width-120, height: gap*2+singgleLineSize.height)
            txtMsg.frame = CGRect(x: 5, y: gap, width: sendView.frame.width-130, height: singgleLineSize.height)
        }
        
    }

    //弹起输入框
    func textViewDidBeginEditing(_ textView: UITextView) {
        let offset: CGFloat = self.view.frame.size.height - 266
        
        if offset > 0 {
            //弹起tableView和输入框
            let frame = sendView.frame
            tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: offset-44)
            sendView.frame = CGRect(x: 0, y: offset-frame.height, width: self.view.frame.size.width, height: frame.height)
            tableView.moveToBottomAuto()
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.handleTap(_:)))
        tableView.addGestureRecognizer(tap)
    }
    
    //收起键盘
    func handleTap(_ sender: UITapGestureRecognizer) {
        if(sender.state == .ended) {
            txtMsg.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    //结束编辑时，
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        tableView.removeGestureRecognizer(tap)
        return true
    }
    
    //收起键盘时，移动整个页面
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let _ = delay(0.1){
            //收回tableView和输入框
            
            let frame = self.sendView.frame
            self.sendView.frame = CGRect(x: 0, y: self.view.frame.size.height-frame.height, width: self.view.frame.size.width, height: frame.height)
            self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.size.height-self.sendView.frame.height)
            self.tableView.moveToBottomAuto()
        }
    }
    
    
//＊＊＊＊＊＊＊＊＊＊＊＊初始化数据和存储数据＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //初始化数据
    func initData(){
        
        myInfo = UserInfo(name: myInfo.username ,icon: myInfo.icon, nickname: myInfo.nickname)
        self.updataYourInfo()
        isOut = true
        
        //读取数据
        let chatsData = SaveDataModel() //保存聊天记录的方法
        let chatData = chatsData.loadChatsDataFromTempDirectory(yourNickname+".plist", key: yourNickname)
        //先把原来的数据保存起来
        chatDataArray = chatData
        
         //读取聊天的图片数据
        let chatCacheImages = SaveCacheDataModel()
        
        for i in 0 ..< chatData.count {
            switch chatData[i].chatType {
                //0 代表对方信息
            case ChatType.someone.rawValue:
                if chatData[i].chatImage == "" {
                    let mesy = MessageItem(body: chatData[i].chatBody as NSString, user: youInfo,  date: chatData[i].chatDate, mtype:ChatType.someone)
                    Chats.add(mesy)
                }else{
                    let imageData = chatCacheImages.loadImageFromChatCacheDir(yourNickname, imageName: chatData[i].chatImage)
                    let image = ChangeValue.dataToImage(imageData)
                    
                    let mesy = MessageItem(image: image, imageName: chatData[i].chatImage, user: youInfo, date: chatData[i].chatDate, mtype: ChatType.someone )
                    Chats.add(mesy)
                }
                //1代表我的信息
            case ChatType.mine.rawValue:
                if chatData[i].chatImage == "" {
                    let mesy = MessageItem(body: chatData[i].chatBody as NSString, user: myInfo,  date: chatData[i].chatDate, mtype:ChatType.mine)
                    Chats.add(mesy)
                }else{
                    let imageData = chatCacheImages.loadImageFromChatCacheDir(yourNickname, imageName: chatData[i].chatImage)
                    let image = ChangeValue.dataToImage(imageData)
                    
                    let mesy = MessageItem(image: image, imageName: chatData[i].chatImage, user: myInfo, date: chatData[i].chatDate, mtype: ChatType.mine)
                    Chats.add(mesy)
                }
                
            default:
                break
            }
        }
    }
    
    func updataYourInfo(){
        let dataArray = SQLLine.SelectAllData(entityNameOfContectors)
        yourNickname = youInfo.nickname
        //保存联系人
        for data in dataArray{
            let nickName = (data as AnyObject).value(forKey: ContectorsNameOfNickname)! as! String
            if nickName == yourNickname{
                let iconData = (data as AnyObject).value(forKey: ContectorsNameOfIcon)! as! Data
                let icon = ChangeValue.dataToImage(iconData)
                let name = (data as AnyObject).value(forKey: ContectorsNameOfName)! as! String
                youInfo.icon = icon
                youInfo.username = name
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
            chatsData.deleteChatsPListFile(yourNickname+".plist") //删除plist文件
            return
        }
        chatsData.saveChatsToTempDirectory(chatData: chatDataArray! ,fileName: yourNickname+".plist", key: yourNickname) //保存时，以对方名字命名，如果名字不一样就不会出错了
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
                let title = (chatList[i] as AnyObject).value(forKey: ChatListNameOfNickname) as! String
                if(title == yourNickname){
                    let _ = SQLLine.DeleteData(entityNameOfChatList, indexPath: i)
                    break
                }
            }
        }
        
        //如果没发送过，就不保存  更新头像和 聊天名
        if(!isChanged){
            for i in 0 ..< chatList.count {
                let title = (chatList[i] as AnyObject).value(forKey: ChatListNameOfNickname) as! String
                if(title == yourNickname){
                    let imageData = ChangeValue.imageToData(youInfo.icon!)
                    let _ = SQLLine.UpdateChatListData(i, changeValue: imageData as AnyObject, changeEntityName: ChatListNameOfIcon)
                    let _ = SQLLine.UpdateChatListData(i, changeValue: youInfo.username as AnyObject, changeEntityName: ChatListNameOfTitle)
                    break
                }
            }
            return
        }
        
        //有消息就写到数据库
        for i in 0 ..< chatList.count {
            let title = (chatList[i] as AnyObject).value(forKey: ChatListNameOfNickname) as! String
            if(title == yourNickname){
                let _ = SQLLine.UpdateChatListData(i, changeValue: time! as AnyObject, changeEntityName: ChatListNameOfTime)
                let _ = SQLLine.UpdateChatListData(i, changeValue: lable! as String as AnyObject, changeEntityName: ChatListNameOfLable)
                break
            }
        }
    }
    
//＊＊＊＊＊＊＊＊＊＊＊＊tableView初始化及代理＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //设置tableView
    func setupChatTable(){
        self.tableView = ChatTableView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-44), style: .plain, chatTitle: self.yourNickname)
        //创建一个重用的单元格
        self.tableView!.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatCell")
        self.view.addSubview(self.tableView)
        
        //set the chatDataSource
        self.tableView.chatDataSource = self
        self.tableView.pushDelegate = self
        self.tableView.reloadData()
        
    }
    
    //行数
    func rowsForChatTable(_ tableView: ChatTableView) -> Int{
        return self.Chats.count
    }
    
    //返回模型数据
    func chatTableView(_ tableView: ChatTableView, dataForRow row:Int) -> MessageItem{
        return Chats[row] as! MessageItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


//点击头像进入个人信息页的代理
extension ChatViewController: ChatTableViewDelegate{
    func pushToPersonInfoView(name: String) {
        let guestContectorVC = ContectorInfoViewController()
        guestContectorVC.contectorName = name
        self.navigationController?.pushViewController(guestContectorVC, animated: true)
    }
}

