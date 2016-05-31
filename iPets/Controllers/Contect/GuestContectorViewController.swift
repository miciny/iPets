//
//  GuestContectViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class GuestContectorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var contectorName: String!
    private var contectorInfo: ContectorModel!
    private var mainTabelView: UITableView? //整个table
    private var contectorInfoData : NSMutableArray?

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
        mainTabelView = UITableView(frame: self.view.frame, style: .Grouped)  //为group模式
        mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        mainTabelView?.showsVerticalScrollIndicator = false
        mainTabelView?.showsHorizontalScrollIndicator = false
        mainTabelView?.separatorStyle = UITableViewCellSeparatorStyle.SingleLine //是否显示线条
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
        let contectors = SQLLine.SelectAllData(entityNameOfContectors)
        
        for i in 0 ..< contectors.count {
            let name = contectors[i].valueForKey(ContectorsNameOfName) as! String
            if(contectorName == name){
                
                //获取返回数据的信息
                let nickname = contectors[i].valueForKey(ContectorsNameOfNickname) as! String
                let sex = contectors[i].valueForKey(ContectorsNameOfSex) as! String
                let remark = contectors[i].valueForKey(ContectorsNameOfRemark) as! String
                let iconData = contectors[i].valueForKey(ContectorsNameOfIcon) as! NSData
                let icon = ChangeValue.dataToImage(iconData)
                let address = contectors[i].valueForKey(ContectorsNameOfAddress) as! String
                let http = contectors[i].valueForKey(ContectorsNameOfHttp) as! String
                
                //弄成contectorModel模型
                contectorInfo = ContectorModel(name: name, sex: sex, nickname: nickname, icon: icon, remark: remark, address: address, http: http)
                
                //加入数据
                let data1 = GuestContectorInfoModel(icon: icon, name: contectorName, nickname: nickname, sex: sex)
                let data2 = GuestContectorInfoModel(remark: remark)
                let data3 = GuestContectorInfoModel(address: address)
                let data4 = GuestContectorInfoModel(http: http)
                
                contectorInfoData?.addObject([data1])
                contectorInfoData?.addObject([data2])
                contectorInfoData?.addObject([data3, data4])
            }
        }
    }
    
    //section个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (contectorInfoData?.count)!
    }
    
    //每个section的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contectorInfoData![section].count
    }
    
    //计算每个cell高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = CGFloat(44)
        switch indexPath.section {
        case 0:  //个人头像栏
            height = 100
        case 2: //地区 个人相册栏
            switch indexPath.row {
            case 1:
                height = 90
            default:
                height = 44
            }
        default:
            height = 44
        }
        
        return height
    }
    
    //每个cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "GuestContectorCell"
        let section : NSArray =  self.contectorInfoData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        
        let cell =  GuestContectorTableViewCell(data:data as! GuestContectorInfoModel, reuseIdentifier:cellId)
        
        switch indexPath.section {
        case 0:
            break
        case 2:
            switch indexPath.row {
            case 0:
                break
            default:
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator  //显示后面的小箭头
            }
        default:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator  //显示后面的小箭头
        }
        
        return cell
    }
    
    //选择了row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mainTabelView!.deselectRowAtIndexPath(indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
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
        footerView.backgroundColor = UIColor.clearColor()
        
        let sendMsgBtn = UIButton(frame: CGRect(x: 10, y: 20, width: Width-20, height: 44))
        sendMsgBtn.backgroundColor = getMainColor()
        sendMsgBtn.setTitle("发消息", forState: .Normal)
        sendMsgBtn.layer.cornerRadius = 5
        sendMsgBtn.addTarget(self, action: #selector(sendMsg), forControlEvents: .TouchUpInside)
        footerView.addSubview(sendMsgBtn)
        
        let videoMsgBtn = UIButton(frame: CGRect(x: 10, y: sendMsgBtn.frame.height + 20 + 20, width: Width-20, height: 44))
        videoMsgBtn.backgroundColor = UIColor.whiteColor()
        videoMsgBtn.setTitle("视频聊天", forState: .Normal)
        videoMsgBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        videoMsgBtn.layer.cornerRadius = 5
        footerView.addSubview(videoMsgBtn)
        
        return footerView
    }
    
    func sendMsg(){
        //同步存储到聊天主界面的数据库
        let chatList = SQLLine.SelectAllData(entityNameOfChatList)
        var isExsit = false
        
        //看原来有没有这个聊天
        for i in 0 ..< chatList.count {
            let title = chatList[i].valueForKey(ChatListNameOfNickname) as! String
            if(title == contectorInfo.nickname){
                isExsit = true
                break
            }
        }
        //如果原先没有这个聊天
        if !isExsit{
            let icon = contectorInfo.icon
            let iconData = ChangeValue.imageToData(icon)
            
            SQLLine.InsertChatListData(contectorInfo.name, lable: "", icon: iconData, time: NSDate(), nickname: contectorInfo.nickname)
        }

        //进入聊天页
        let chatView = ChatViewController()
        chatView.youInfo = UserInfo(name: contectorInfo.name, icon: contectorInfo.icon, nickname: contectorInfo.nickname)
        chatView.hidesBottomBarWhenPushed = true
        
        //导航
        let viewArray = NSMutableArray()
        viewArray.addObjectsFromArray((self.navigationController?.viewControllers)!)
        //删两次
        viewArray.removeObjectAtIndex(1)
        viewArray.removeObjectAtIndex(1)
        
        viewArray.addObject(chatView)
        //重新设置导航器，执行动画
        self.navigationController?.setViewControllers(viewArray as NSArray as! [UIViewController], animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //第一个section距离navigationbar的距离,第一个和第二个的间距设置，用mainTabelView?.sectionFooterHeight = 10，这个距离的计算是header的高度加上footer的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}
