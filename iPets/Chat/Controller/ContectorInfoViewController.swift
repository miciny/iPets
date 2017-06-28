//
//  GuestContectViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ContectorInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var contectorNickName: String!
    fileprivate var contectorInfo: ContectorModel!
    fileprivate var mainTabelView: UITableView? //整个table
    fileprivate var contectorInfoData: NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setData()
        setUpTable()
    }
    
    func setUpEles(){
        self.title = "详细资料"
        self.view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    //设置tableView
    func setUpTable(){
        mainTabelView = UITableView(frame: self.view.frame, style: .grouped)  //为group模式
        mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        mainTabelView?.showsVerticalScrollIndicator = false
        mainTabelView?.showsHorizontalScrollIndicator = false
        mainTabelView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine //是否显示线条
        mainTabelView?.sectionFooterHeight = 5  //每个section的间距
        
        mainTabelView?.delegate = self
        mainTabelView?.dataSource = self
        
        mainTabelView?.tableFooterView = setFooterView() // 设置footerView
        
        self.view.addSubview(mainTabelView!)
    }
    
    //数据
    func setData(){
        contectorInfoData = NSMutableArray()
        //获取联系人信息
        
        if let contectors = SQLLine.SelectedCordData("nickname='"+contectorNickName+"'", entityName: entityNameOfContectors){
            //获取返回数据的信息
            let name = (contectors[0] as! Contectors).name!
            let sex = (contectors[0] as! Contectors).sex!
            let remark = (contectors[0] as! Contectors).remark!
            let iconData = (contectors[0] as! Contectors).icon!
            let icon = ChangeValue.dataToImage(iconData as Data)
            let address = (contectors[0] as! Contectors).address!
            let http = (contectors[0]as! Contectors).http!
            
            //弄成contectorModel模型
            contectorInfo = ContectorModel(name: name, sex: sex, nickname: contectorNickName, icon: icon, remark: remark, address: address, http: http)
            
            //加入数据
            let data1 = ContectorInfoViewDataModel(icon: icon, name: name, nickname: contectorNickName, sex: sex)
            let data2 = ContectorInfoViewDataModel(remark: remark)
            let data3 = ContectorInfoViewDataModel(address: address)
            let data4 = ContectorInfoViewDataModel(http: http)
            
            contectorInfoData?.add([data1])
            contectorInfoData?.add([data2])
            contectorInfoData?.add([data3, data4])

        }
    }
    
    //section个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return (contectorInfoData?.count)!
    }
    
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contectorInfoData![section] as AnyObject).count
    }
    
    //计算每个cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section =  self.contectorInfoData![indexPath.section] as! NSArray
        let data = section[indexPath.row] as! ContectorInfoViewDataModel
        return data.height
    }
    
    //每个cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "GuestContectorCell"
        let section =  self.contectorInfoData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        
        let cell =  ContectorInfoTableViewCell(data: data as! ContectorInfoViewDataModel, reuseIdentifier: cellId)

        return cell
    }
    
    //选择了row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabelView!.deselectRow(at: indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        switch indexPath.section{
            //标签
        case 1:
            break
        default:
            break
        }
    }
    
    //footerView
    func setFooterView() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 120))
        footerView.backgroundColor = UIColor.clear
        
        let sendMsgBtn = UIButton(frame: CGRect(x: 10, y: 20, width: Width-20, height: 44))
        sendMsgBtn.backgroundColor = getMainColor()
        sendMsgBtn.setTitle("发消息", for: UIControlState())
        sendMsgBtn.layer.cornerRadius = 5
        sendMsgBtn.addTarget(self, action: #selector(sendMsg), for: .touchUpInside)
        footerView.addSubview(sendMsgBtn)
        
        let videoMsgBtn = UIButton(frame: CGRect(x: 10, y: sendMsgBtn.frame.height + 20 + 20, width: Width-20, height: 44))
        videoMsgBtn.backgroundColor = UIColor.white
        videoMsgBtn.setTitle("视频聊天（测试朋友圈）", for: UIControlState())
        videoMsgBtn.setTitleColor(UIColor.black, for: UIControlState())
        videoMsgBtn.addTarget(self, action: #selector(sendCircle), for: .touchUpInside)
        videoMsgBtn.layer.cornerRadius = 5
        footerView.addSubview(videoMsgBtn)
        
        return footerView
    }
    
    func sendCircle(){
        let data = SaveDataModel()
        data.setUserData(key: "Circle", value: contectorNickName as Any)
        
        
        var oldData = data.loadFindMyPetsDataFromTempDirectory()
        let myFindPetsInfo = FindPetsCellModel(name: contectorInfo.name, text: "这是我测试的数据，千万不要以为我不知道，我是真的可以做到的，啊哈哈哈哈哈哈哈哈！！！！", picture: nil, date: Date(), nickname: contectorNickName, video: nil, from: .other)
        oldData.append(myFindPetsInfo)
        //保存寻宠数据
        data.saveFindMyPetsToTempDirectory(oldData)
        
        
        ToastView().showToast("发送成功")
    }
    
    func sendMsg(){
        //同步存储到聊天主界面的数据库
        var isExsit = false
        
        //看原来有没有这个聊天
        if let data = SQLLine.SelectedCordData("nickname='"+contectorInfo.nickname+"'", entityName: entityNameOfChatList){
            if data.count == 1{
                isExsit = true
            }
        }
        
        //如果原先没有这个聊天
        if !isExsit{
            //数据库
            let icon = contectorInfo.icon
            let iconData = ChangeValue.imageToData(icon)
            
            let _ = SQLLine.InsertChatListData(contectorInfo.name, lable: "", icon: iconData!, time: Date(), nickname: contectorInfo.nickname, unread: 0)
            print(contectorInfo.name + "的聊天数据库保存成功")
            
            //聊天的设置数据保存
            let chatsData = SaveDataModel()
            var chatSettingData = chatsData.loadChatSettingDataFromTempDirectory()
            
            let settingData = MainChatListViewDataSettingModel(nickname: contectorInfo.nickname, top: "0",
                                                               chatBIMPath: nil, notNotice: "0")
            chatSettingData.append(settingData)
            
            chatsData.saveChatSettingToTempDirectory(settingData: chatSettingData)
        }

        //进入聊天页
        let chatView = ChatViewController()
        if let data = ChatFuncs.getSettingModel(contectorNickName){
            if data.chatBIMPath != nil{
                chatView.backImageView = UIImageView() //设置了说明有背景图片
            }
        }
        chatView.youInfo = UserInfo(name: contectorInfo.name, icon: contectorInfo.icon, nickname: contectorInfo.nickname)
        chatView.hidesBottomBarWhenPushed = true
        
        //导航
        let tabView = (self.navigationController?.viewControllers[0])!
        var viewArray = (self.navigationController?.viewControllers)!
        viewArray.removeAll()
        
        viewArray.append(tabView)
        viewArray.append(chatView)
        //重新设置导航器，执行动画
        self.navigationController?.setViewControllers(viewArray, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //第一个section距离navigationbar的距离,第一个和第二个的间距设置，用mainTabelView?.sectionFooterHeight = 10，这个距离的计算是header的高度加上footer的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}
