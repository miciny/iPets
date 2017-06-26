//
//  ChatViewController.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/16.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import AssetsLibrary
import Social
import AVFoundation

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
    
    fileprivate var voiceButton: UIImageView!
    fileprivate var voiceBtn: UIButton?
    fileprivate var voiceTap: UITapGestureRecognizer?
    fileprivate var keyboradTap: UITapGestureRecognizer?
    
    var backImageView: UIImageView? //设置了说明有背景图片
    
    var activityViewController: UIActivityViewController?
    
    var recorder: AudioRecorder? //录音器
    var aacPath: String?
    
    var offset = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        Chats = NSMutableArray()
        chatDataArray = [ChatData]()
        offset = self.view.frame.size.height - 256
        
        initData()
        
        setupChatTable()
        setupSendPanel()
        
        self.tableView.moveToBottomFirst()
    }
    
    //退出时保存数据
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
        if let _ = audioPlayer{
            audioPlayer!.stopAudio()
            audioPlayer = nil
        }
        
        globalQueue.async(execute: {
            //这里写需要放到子线程做的耗时的代码
            
            self.saveChatData()
            self.saveChatList()
            
            mainQueue.async(execute: {
                print("与"+self.yourNickname+"的聊天数据保存成功")
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshBIM()
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
        voiceButton = UIImageView(frame:CGRect(x: 4, y: 8, width: 28, height: 28))
        voiceButton.backgroundColor = UIColor.clear
        voiceButton.image = UIImage(named: "Sound")
        sendView.addSubview(voiceButton)
        
        voiceButton.isUserInteractionEnabled = true
        voiceButton.image = UIImage(named: "Sound")
        if let tap = self.keyboradTap{
            voiceButton.removeGestureRecognizer(tap)
        }
        voiceTap = UITapGestureRecognizer(target: self, action: #selector(self.changeAudioView))
        voiceButton.addGestureRecognizer(voiceTap!)
        sendView.addSubview(voiceButton)
        
        // 右边＋按钮
        let addButton = UIImageView(frame:CGRect(x: Width-40, y: 4, width: 36, height: 36))
        addButton.backgroundColor = UIColor.clear
        addButton.image = UIImage(named: "AddMoreFuns")
        
        addButton.isUserInteractionEnabled = true
        let addTap = UITapGestureRecognizer(target: self, action: #selector(self.goToImageCollectionView))
        addButton.addGestureRecognizer(addTap)
        sendView.addSubview(addButton)
        
        //右边表情按钮
        let emotionButton = UIImageView(frame:CGRect(x: sendView.frame.width-80, y: 4, width: 36, height: 36))
        emotionButton.backgroundColor=UIColor.clear
        emotionButton.image = UIImage(named: "Emotion")
        
        emotionButton.isUserInteractionEnabled = true
        let motionTap = UITapGestureRecognizer(target: self, action: #selector(self.motionAdd))
        emotionButton.addGestureRecognizer(motionTap)
        sendView.addSubview(emotionButton)
        
        self.view.addSubview(sendView)
    }
    
    //选择表情
    func motionAdd(){
        
    }
    
//============================================发送和接受语音消息＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    
    func changeAudioView(){
        
        txtMsgView.isHidden = true
        txtMsg.resignFirstResponder()
        
        voiceBtn = UIButton()
        voiceBtn!.frame = txtMsgView.frame
        if let superView = txtMsgView.superview{
            superView.addSubview(voiceBtn!)
            voiceBtn!.setTitle("按住 说话", for: .normal)
            voiceBtn!.setTitle("松开 发送", for: .highlighted)
            voiceBtn!.setTitleColor(UIColor.black, for: .normal)
            voiceBtn!.setTitleColor(UIColor.red, for: .highlighted)
            voiceBtn!.layer.cornerRadius = 8
            voiceBtn!.layer.borderColor = UIColor.lightGray.cgColor
            voiceBtn!.layer.borderWidth = 0.5
            
            voiceBtn!.addTarget(self, action: #selector(setUpRecorder), for: .touchDown)
            voiceBtn!.addTarget(self, action: #selector(endRecord), for: .touchUpInside)
        }
        
        voiceButton.image = UIImage(named: "Keyboard")
        if let tap = self.voiceTap{
            voiceButton.removeGestureRecognizer(tap)
        }
        keyboradTap = UITapGestureRecognizer(target: self, action: #selector(self.changeKeyboradView))
        voiceButton.addGestureRecognizer(keyboradTap!)
        
    }
    
    func changeKeyboradView(){
        voiceBtn?.removeFromSuperview()
        voiceBtn = nil
        
        txtMsgView.isHidden = false
        txtMsg.becomeFirstResponder()
        
        voiceButton.image = UIImage(named: "Sound")
        if let tap = self.keyboradTap{
            voiceButton.removeGestureRecognizer(tap)
        }
        voiceTap = UITapGestureRecognizer(target: self, action: #selector(self.changeAudioView))
        voiceButton.addGestureRecognizer(voiceTap!)
        
        recorder = nil
    }
    
    func setUpRecorder(){
        
        if let _ = audioPlayer{
            audioPlayer!.stopAudio()
            audioPlayer = nil
        }
        
        let timeStr = DateToToString.dateToStringBySelf(Date(), format: "yyyyMMdd_HHmmss_ssss")
        //组合录音文件路径,会自动替换
        aacPath = (SaveCacheDataModel().createDirInChatCache(youInfo.nickname!) as! String) + "/" + timeStr + ".aac"
        
        if recorder != nil{
            recorder = nil
        }
        
        recorder = AudioRecorder(path: aacPath!)
        self.beginRecord()
    }
    
    
    func beginRecord(){
        recorder?.beginRecord()
    }


    func endRecord(){
        //停止录音
        let timeInt = recorder?.endRecord()
        let timeStr = String(Int(timeInt!))
        //录音器释放
        recorder = nil
        
        ToastView().showToast("结束录音")
        
        let time = Date()
        
        let thisChat = MessageItem(voicePath: aacPath!, voiceLong: timeStr, user: myInfo, date: time, mtype: .mine)
        self.Chats.add(thisChat)
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        isChanged = true
        
        let sendedVoice = ChatData(chatType: ChatType.mine.rawValue, time: time, voicePath: aacPath!, voiceLong: timeStr)
        self.chatDataArray?.append(sendedVoice)
        
        self.time = time
        lable = "[语音]"
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
                
                let sendedImage = ChatData(chatType: ChatType.mine.rawValue, time: timeArray[j], chatImage: timestrArray[j])
                
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
            ToastView().showToast("消息不能为空")
            txtMsg.resignFirstResponder()
            return
        }
        
        //MessageItem格式的 就可以展示了
        let thisChat = MessageItem(body: msg, user: myInfo, date: time1, mtype: ChatType.mine)
        let thatChat = MessageItem(body: "你说的是：\(msg)", user: youInfo, date: self.time!, mtype: ChatType.someone)
        Chats.add(thisChat)
        Chats.add(thatChat)
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        lable = "你说的是：\(msg)"
        isChanged = true
        txtMsg.text = ""
        
        globalQueue.async(execute: {
            
            //同步保存数据
            let first1 = ChatData(chatType: ChatType.mine.rawValue, time: time1, chatBody: msg)
            let first2 = ChatData(chatType: ChatType.someone.rawValue, time: self.time!, chatBody: "你说的是：\(msg)")
            self.chatDataArray?.append(first1)
            self.chatDataArray?.append(first2)
            
            mainQueue.async(execute: {
                self.saveChatData()
            })
        })
    }
    
//＊＊＊＊＊＊＊＊＊＊＊＊键盘相关代理＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    
    //键盘的return键
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //发送按钮 ， 发送直接返回
        if (text == "\n"){
            sendMessage()
            return true
        }
        
        //获得新的字符串
        let newText = textView.text!.replacingCharacters(
            in: range.toRange(string: textView.text!), with: text)
        
        let textViewSize = sizeWithText(newText, font: chatPageInputTextFont, maxSize: CGSize(width: sendView.frame.width-130, height: 1000))
        let singgleLineSize1 = sizeWithText("我爱你！", font: chatPageInputTextFont, maxSize: CGSize(width: sendView.frame.width-130, height: 1000))
        
        //获取行数，可能不是很准
        let i = textViewSize.height/singgleLineSize1.height
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
        
        if offset > 0 {
            //弹起tableView和输入框
            let frame = sendView.frame
            tableView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: offset-110)
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
            self.tableView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: Height-self.sendView.frame.height-64)
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
                
                if chatData[i].messageType == "0" {
                    let mesy = MessageItem(body: chatData[i].chatBody!, user: youInfo,  date: chatData[i].chatDate, mtype: ChatType.someone)
                    Chats.add(mesy)
                }else if chatData[i].messageType == "1" {
                    let imageData = chatCacheImages.loadImageFromChatCacheDir(yourNickname, imageName: chatData[i].chatImage!)
                    let image = ChangeValue.dataToImage(imageData)
                    
                    let mesy = MessageItem(image: image, imageName: chatData[i].chatImage!, user: youInfo, date: chatData[i].chatDate, mtype: ChatType.someone )
                    Chats.add(mesy)
                }else if chatData[i].messageType == "2" {
                    
                    let mesy = MessageItem(voicePath: chatData[i].voicePath!, voiceLong: chatData[i].voiceLong!, user: youInfo, date: chatData[i].chatDate, mtype: .someone)
                    Chats.add(mesy)
                }
                //1代表我的信息
            case ChatType.mine.rawValue:
                
                if chatData[i].messageType == "0" {
                    let mesy = MessageItem(body: chatData[i].chatBody!, user: myInfo,  date: chatData[i].chatDate, mtype:ChatType.mine)
                    Chats.add(mesy)
                }else if chatData[i].messageType == "1"{
                    let imageData = chatCacheImages.loadImageFromChatCacheDir(yourNickname, imageName: chatData[i].chatImage!)
                    let image = ChangeValue.dataToImage(imageData)
                    
                    let mesy = MessageItem(image: image, imageName: chatData[i].chatImage!, user: myInfo, date: chatData[i].chatDate, mtype: ChatType.mine)
                    Chats.add(mesy)
                }else if chatData[i].messageType == "2" {
                    let mesy = MessageItem(voicePath: chatData[i].voicePath!, voiceLong: chatData[i].voiceLong!, user: myInfo, date: chatData[i].chatDate, mtype: .mine)
                    Chats.add(mesy)
                }
                
            default:
                break
            }
        }
    }
    
    func updataYourInfo(){
        
        yourNickname = youInfo.nickname
        
        if let data = SQLLine.SelectedCordData("nickname='"+yourNickname+"'", entityName: entityNameOfContectors){
            let iconData = (data[0] as! Contectors).icon! as Data
            let icon = ChangeValue.dataToImage(iconData)
            let name = (data[0] as! Contectors).name!
            
            youInfo.icon = icon
            youInfo.username = name
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
        
        if chatDataArray!.count == 0{
            //没消息就删数据库
            if SQLLine.DeleteData(entityNameOfChatList, condition: "nickname='"+yourNickname+"'"){
                print("删除"+yourNickname+"聊天数据库成功！")
            }else{
                print("删除"+yourNickname+"聊天数据库失败！")
            }
        }
        
        //如果没发送过，就不保存  更新头像和 聊天名
        if(!isChanged){
            
            let imageData = ChangeValue.imageToData(youInfo.icon!)
            let _ = SQLLine.UpdateDataWithCondition("nickname='"+yourNickname+"'", entityName: entityNameOfChatList, changeValue: imageData as AnyObject, changeEntityName: "icon")
            let _ = SQLLine.UpdateDataWithCondition("nickname='"+yourNickname+"'", entityName: entityNameOfChatList, changeValue: youInfo.username as AnyObject, changeEntityName: "title")
            
            return
        }
        
        
        let _ = SQLLine.UpdateDataWithCondition("nickname='"+yourNickname+"'", entityName: entityNameOfChatList, changeValue: time! as AnyObject, changeEntityName: "time")
        let _ = SQLLine.UpdateDataWithCondition("nickname='"+yourNickname+"'", entityName: entityNameOfChatList, changeValue: lable! as AnyObject, changeEntityName: "lable")
    }
    
//＊＊＊＊＊＊＊＊＊＊＊＊tableView初始化及代理＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //设置tableView
    func setupChatTable(){
        
        //背景图
        if let backImageView = backImageView{
            backImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-44)
            self.view.addSubview(backImageView)
            self.refreshBIM()
        }
        
        //table
        self.tableView = ChatTableView(frame: CGRect(x: 0, y: 64, width: Width, height: Height-105), style: .plain, chatTitle: self.yourNickname)
        //创建一个重用的单元格
        self.tableView!.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatCell")
        self.view.addSubview(self.tableView)
        
        //set the chatDataSource
        self.tableView.chatDataSource = self
        self.tableView.pushDelegate = self
        self.tableView.reloadData()
        
        //左上角联系人按钮按钮，一下方法添加图片，需要对图片进行遮罩处理，否则不会出现图片
        // 我们会发现出来的是一个纯色的图片，是因为iOS扁平化设计风格应用之后做成这样的，如果需要现实图片，我们可以设置一项
        var image = UIImage(named:"ChatSetting")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let contectItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(goChatInfoView))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)  //用于消除左边空隙，要不然按钮顶不到最前面
        spacer.width = -5
        
        self.navigationItem.rightBarButtonItems = [spacer, contectItem]
        
    }
    
    func goChatInfoView(){
        let vc = ChatInfoViewController()
        vc.contectorNickName = yourNickname
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func refreshBIM(){
        if let bim = self.backImageView{
            let saveCache = SaveCacheDataModel()
            let imageViewData = saveCache.loadImageFromChatCacheDir(self.yourNickname, imageName: "BIM.png")
            let imageView = ChangeValue.dataToImage(imageViewData)
            bim.image = imageView
        }
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
        guestContectorVC.contectorNickName = name
        self.navigationController?.pushViewController(guestContectorVC, animated: true)
    }
    
    func shartImage(image: UIImage) {
        self.share(image: image)
    }
    
    func share(image: UIImage){
        
        if self.activityViewController != nil {
            self.activityViewController = nil
        }
        
        let title = (myInfo.username! + "的寻宠二维码")
        let url = (URL(fileURLWithPath: myOwnUrl))
        
        let activityItems: NSArray = [title, image, url]
        
        activityViewController = UIActivityViewController(activityItems: activityItems as! [Any], applicationActivities: nil)
        //排除一些服务：例如复制到粘贴板，拷贝到通讯录
        activityViewController!.excludedActivityTypes = [UIActivityType.copyToPasteboard,
                                                         UIActivityType.assignToContact,
                                                         UIActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
                                                         UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension")]
        
        self.present(activityViewController!, animated: true, completion: nil)
        
        activityViewController!.completionWithItemsHandler =
            {  (activityType: UIActivityType?,
                completed: Bool,
                returnedItems: [Any]?,
                error: Error?) in
                
                print(activityType ?? "没有获取到分享路径")
                
                print(returnedItems ?? "没有获取到返回路径")
                
                if completed{
                    ToastView().showToast("分享成功！")
                }else{
                    ToastView().showToast("用户取消！")
                }
                
                if let e = error{
                    print("分享错误")
                    print(e)
                }
                
                self.activityViewController = nil
        }
        
    }

}

