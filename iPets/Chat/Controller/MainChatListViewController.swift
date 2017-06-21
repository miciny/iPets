//
//  ContectViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import MCYRefresher

class MainChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var headerView: MCYRefreshView? //自己写的
    
    fileprivate var mainTabelView: UITableView? //整个table
    fileprivate var chatData : NSMutableArray? //数据
    fileprivate let addArray : NSDictionary = ["发起群聊": "AddNewMessage",
                                               "添加朋友": "AddFriends",
                                               "扫一扫": "AddScan"]
    fileprivate var addActionView: ActionMenuView?  //此处定义，方便显示和消失的判断

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setData()
        setUpTable()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setData()
        self.mainTabelView?.reloadData()
        
//        self.navigationController?.tabBarItem.badgeValue = "99" //设置数的
    }
    
    //退出界面，菜单消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if addActionView != nil {
            addActionView?.hideView()
        }
    }
    
//＊＊＊＊＊＊＊＊＊＊＊＊初始页面元素＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    func setUpEles(){
        self.title = "聊天"                           //页面title和底部title
        self.navigationItem.title = "聊天"        //再次设置顶部title,这样才可以和tabbar上的title不一样
        self.view.backgroundColor = UIColor.white //背景色
        
        //右上角添加按钮
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.addButtonClicked))
        self.navigationItem.rightBarButtonItem = addItem
        
        //左上角联系人按钮按钮，一下方法添加图片，需要对图片进行遮罩处理，否则不会出现图片
        // 我们会发现出来的是一个纯色的图片，是因为iOS扁平化设计风格应用之后做成这样的，如果需要现实图片，我们可以设置一项
        var image = UIImage(named:"contectIcon")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let contectItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(goToContectView))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)  //用于消除左边空隙，要不然按钮顶不到最前面
        spacer.width = -5
        
        self.navigationItem.leftBarButtonItems = [spacer, contectItem]
    }
    
//＊＊＊＊＊＊＊＊＊＊＊＊导航栏按钮功能＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    
    //左上角按钮，进入联系人页
    func goToContectView(){
        
        let contectorsListVc = ContectorListViewController()
        contectorsListVc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(contectorsListVc, animated: true)
        
    }
    
    //右上角添加按钮的事件
    func addButtonClicked(){
        if(addActionView?.superview == nil){
            addActionView = ActionMenuView(object: addArray, origin: CGPoint(x: Width, y: navigateBarHeight), target: self, showInView: self.view)
        }else{
            addActionView?.hideView()
            addActionView?.removeFromSuperview()
        }
    }
    
//＊＊＊＊＊＊＊＊****************＊＊＊＊初始化数据＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    
    func setData(){
        chatData = NSMutableArray()
        
        let chatList = SQLLine.SelectAllData(entityNameOfChatList)
        
        for i in 0 ..< chatList.count {
            let title = (chatList[i] as AnyObject).value(forKey: ChatListNameOfTitle) as! String
            let lable = (chatList[i] as AnyObject).value(forKey: ChatListNameOfLable) as! String
            let time = (chatList[i] as AnyObject).value(forKey: ChatListNameOfTime) as! Date
            let iconDate = (chatList[i] as AnyObject).value(forKey: ChatListNameOfIcon) as! Data
            let icon = UIImage(data: iconDate)!
            let nickname = (chatList[i] as AnyObject).value(forKey: ChatListNameOfNickname) as! String
            
            let singleChatList = MainChatListViewDataModel(pic: icon, name: title, lable: lable,
                                                           time: time, nickname: nickname, unreadCount: 0)
            chatData!.add(singleChatList)
        }
        
        //排序，按时间倒序
        
        guard chatData!.count > 0 else {
            return
        }
        
        chatData?.sort(comparator: { (m1, m2) -> ComparisonResult in
            if((m1 as! MainChatListViewDataModel).time.timeIntervalSince1970 > (m2 as! MainChatListViewDataModel).time.timeIntervalSince1970){
                return ComparisonResult.orderedAscending
            }else{
                return ComparisonResult.orderedDescending
            }
        })
    }
//＊＊＊＊＊＊＊＊＊＊＊＊初始化tableView以及代理方法＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //设置tableView
    func setUpTable(){
        mainTabelView = UITableView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))  //为普通模式
        mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        mainTabelView?.showsHorizontalScrollIndicator = false
        mainTabelView?.tableFooterView = UIView(frame: CGRect.zero) //消除底部多余的线
        
        mainTabelView?.delegate = self
        mainTabelView?.dataSource = self
        
        headerView =  MCYRefreshView(subView: mainTabelView!, target: self, imageName: "tableview_pull_refresh")  //添加下拉刷新
        
        self.view.addSubview(mainTabelView!)
    }
    
    //section个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData!.count
    }
    
    //计算每个cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = chatData![indexPath.row]
        let item =  data as! MainChatListViewDataModel
        let height  = item.height
        
        return height
    }
    
    //每个cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "MainChatListCell"
        let data = chatData![indexPath.row]
        let cell =  MainChatTableViewCell(data: data as! MainChatListViewDataModel, reuseIdentifier:cellId)
        
        return cell
    }
    
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabelView!.deselectRow(at: indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        let data = chatData![indexPath.row]
        let item =  data as! MainChatListViewDataModel
        
        let chatView = ChatViewController()
        chatView.hidesBottomBarWhenPushed = true
        chatView.youInfo = UserInfo(name: item.name, icon: item.pic, nickname: item.nickname)
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    
    //支持编辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //操作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    //删除操作
    func deleteChatData(indexPath: IndexPath){
        //删除图片的文件夹
        let data = chatData![indexPath.row]
        let item =  data as! MainChatListViewDataModel
        
        let chatsCache = SaveCacheDataModel()
        chatsCache.deleteDirInChatCache(item.nickname)
        
        //删除plist文件
        let chatsData = SaveDataModel()
        chatsData.deleteChatsPListFile("\(item.nickname).plist") //删除plist文件
        
        //删除数据库
        let chatList = SQLLine.SelectAllData(entityNameOfChatList)
        
        for i in 0 ..< chatList.count {
            let title = (chatList[i] as AnyObject).value(forKey: ChatListNameOfNickname) as! String
            if(title == item.nickname){
                if SQLLine.DeleteData(entityNameOfChatList, indexPath: i){
                    print("删除"+title+"聊天数据库成功！")
                }else{
                    print("删除"+title+"聊天数据库失败！")
                }
                break
            }
        }
        
        chatData?.removeObject(at: indexPath.row)  //删本地数据
        self.mainTabelView!.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    //标记未读
    func unreadData(indexPath: IndexPath){
        let data = chatData![indexPath.row]
        let item =  data as! MainChatListViewDataModel
        item.unreadCount = 1
        
        self.mainTabelView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //删除
        let delete = UITableViewRowAction(style: .normal, title: "删除") { action, index in
            self.deleteChatData(indexPath: indexPath)
        }
        delete.backgroundColor = UIColor.red
        
        //标记未读
        let setUnread = UITableViewRowAction(style: .normal, title: "标记未读") { action, index in
            self.unreadData(indexPath: indexPath)
        }
        setUnread.backgroundColor = UIColor.lightGray
        
        return [delete, setUnread]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//===========================actionview 代理========================
extension MainChatListViewController: actionMenuViewDelegate{
    //actionMenuView的代理方法
    func menuClicked(_ tag: Int) {
        switch tag{
        case 0:
            ToastView().showToast(addArray.allKeys[0] as! String)
        case 1:
            ToastView().showToast(addArray.allKeys[1] as! String)
            
        //扫一扫界面
        case 2:
            let TDCodeVc = RichScanViewController()
            TDCodeVc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(TDCodeVc, animated: true)
        default:
            break
        }
    }
}

extension MainChatListViewController: MCYRefreshViewDelegate{
    //isfreshing中的代理方法
    func reFreshing(){
        
        let _ = delay(0.5){
            self.setData()
            self.mainTabelView?.reloadData()
            self.headerView?.endRefresh()
            
            ToastView().showToast("刷新完成！")
        }
    }

}
