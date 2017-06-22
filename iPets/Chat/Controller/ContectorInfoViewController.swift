//
//  GuestContectViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ContectorInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var contectorName: String!
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
        
        if let contectors = SQLLine.SelectedCordData("name='"+contectorName+"'", entityName: entityNameOfContectors){
            //获取返回数据的信息
            let nickname = (contectors[0] as! Contectors).nickname!
            let sex = (contectors[0] as! Contectors).sex!
            let remark = (contectors[0] as! Contectors).remark!
            let iconData = (contectors[0] as! Contectors).icon!
            let icon = ChangeValue.dataToImage(iconData as Data)
            let address = (contectors[0] as! Contectors).address!
            let http = (contectors[0]as! Contectors).http!
            
            //弄成contectorModel模型
            contectorInfo = ContectorModel(name: contectorName, sex: sex, nickname: nickname, icon: icon, remark: remark, address: address, http: http)
            
            //加入数据
            let data1 = ContectorInfoViewDataModel(icon: icon, name: contectorName, nickname: nickname, sex: sex)
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "GuestContectorCell"
        let section : NSArray =  self.contectorInfoData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        
        let cell =  ContectorInfoTableViewCell(data: data as! ContectorInfoViewDataModel, reuseIdentifier: cellId)
        
        switch indexPath.section {
        case 0:
            break
        case 2:
            switch indexPath.row {
            case 0:
                break
            default:
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator  //显示后面的小箭头
            }
        default:
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator  //显示后面的小箭头
        }
        
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
        videoMsgBtn.setTitle("视频聊天", for: UIControlState())
        videoMsgBtn.setTitleColor(UIColor.black, for: UIControlState())
        videoMsgBtn.layer.cornerRadius = 5
        footerView.addSubview(videoMsgBtn)
        
        return footerView
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
            let icon = contectorInfo.icon
            let iconData = ChangeValue.imageToData(icon)
            
            let _ = SQLLine.InsertChatListData(contectorInfo.name, lable: "", icon: iconData!, time: Date(), nickname: contectorInfo.nickname, unread: "0")
            print(contectorInfo.name + "的聊天数据库保存成功")
        }

        //进入聊天页
        let chatView = ChatViewController()
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
