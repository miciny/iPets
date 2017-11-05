//
//  ChatInfoViewController.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class ChatInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var contectorNickName: String!
    
    fileprivate var mainTabelView: UITableView? //整个table
    fileprivate var dataSource: NSMutableArray?
    fileprivate var picker: UIImagePickerController?
    
    private var topS: UISwitch?
    private var noticeS: UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setData()
        setUpTable()
    }
    
    func setUpEles(){
        self.title = "聊天详情"
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
        
        self.view.addSubview(mainTabelView!)
    }
    
    //数据
    func setData(){
        dataSource = NSMutableArray()
        
        if let contectors = SQLLine.SelectedCordData("nickname='"+contectorNickName+"'", entityName: entityNameOfContectors){
            //获取返回数据的信息
            let name = (contectors[0] as! Contectors).name!
            let iconData = (contectors[0] as! Contectors).icon!
            let icon = ChangeValue.dataToImage(iconData as Data)
            
            //获得设置的置顶消息
            var mesNotNotice = false
            var notNotice = false
            if let data = ChatFuncs.getSettingModel(contectorNickName){
                mesNotNotice = (data.top == "1") ? true : false
                notNotice = (data.notNotice == "1") ? true : false
            }
            //加入数据
            let data1 = ChatInfoViewDataModel(icon: icon, name: name, nickname: contectorNickName)
            let data2 = ChatInfoViewDataModel(label: "消息置顶", isSwitch: mesNotNotice)
            let data3 = ChatInfoViewDataModel(label: "消息免打扰", isSwitch: notNotice)
            let data4 = ChatInfoViewDataModel(label: "设置聊天背景")
            
            dataSource?.add([data1])
            dataSource?.add([data2, data3])
            dataSource?.add([data4])
        }
    }
    
    //section个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return (dataSource?.count)!
    }
    
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource![section] as AnyObject).count
    }
    
    //计算每个cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.dataSource![indexPath.section] as! NSArray
        let data = section[indexPath.row] as! ChatInfoViewDataModel
        return data.height
    }
    
    //每个cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "ChatInfoViewCell"
        let section =  self.dataSource![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        
        let cell =  ChatInfoTableViewCell(data: data as! ChatInfoViewDataModel, reuseIdentifier: cellId)
        
        if indexPath.section == 1 && indexPath.row == 0{
            topS = cell.topSwitch
            topS?.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        }
        if indexPath.section == 1 && indexPath.row == 1{
            noticeS = cell.topSwitch
            noticeS?.addTarget(self, action: #selector(switchChanged_Notice), for: .valueChanged)
        }
        
        return cell
    }
    
    //选择了row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabelView!.deselectRow(at: indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        if indexPath.section == 2 && indexPath.row == 0{
            let bottomMenu = MyBottomMenuView()
            bottomMenu.showBottomMenu("", cancel: "取消", object: ["拍照", "相册选择"], eventFlag: 0, target: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //第一个section距离navigationbar的距离,第一个和第二个的间距设置，用mainTabelView?.sectionFooterHeight = 10，这个距离的计算是header的高度加上footer的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    @objc func switchChanged_Notice(){
        //聊天的设置数据保存
        let chatsData = SaveDataModel()
        var chatSettingData = chatsData.loadChatSettingDataFromTempDirectory()
        
        //获得设置的置顶消息
        for i in 0 ..< chatSettingData.count{
            let data = chatSettingData[i]
            let nickname = data.nickname
            if nickname == contectorNickName{
                if (noticeS?.isOn)! {
                    data.notNotice = "1"
                }else{
                    data.notNotice = "0"
                }
                
                chatSettingData.remove(at: i)
                chatSettingData.append(data)
                break
            }
        }
        chatsData.saveChatSettingToTempDirectory(settingData: chatSettingData)

    }
    
    @objc func switchChanged(){
        //聊天的设置数据保存
        let chatsData = SaveDataModel()
        var chatSettingData = chatsData.loadChatSettingDataFromTempDirectory()
        
        //获得设置的置顶消息
        for i in 0 ..< chatSettingData.count{
            let data = chatSettingData[i]
            let nickname = data.nickname
            if nickname == contectorNickName{
                if (topS?.isOn)! {
                    data.top = "1"
                }else{
                    data.top = "0"
                }
                
                chatSettingData.remove(at: i)
                chatSettingData.append(data)
                break
            }
        }
        chatsData.saveChatSettingToTempDirectory(settingData: chatSettingData)
    }
}

//选择的协议
extension ChatInfoViewController: bottomMenuViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func buttonClicked(_ tag: Int, eventFlag: Int) {
        switch eventFlag{
        case 0:
            switch tag{
            case 0:
                takePhoto()
            case 1:
                localPhoto()
            default:
                break
            }
        default:
            break
        }
    }
    
    //拍照
    func takePhoto(){
        let sourceType : UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker = UIImagePickerController()
            picker?.delegate = self
            picker!.allowsEditing = true
            picker?.sourceType = sourceType
            self.present(picker!, animated:true, completion: nil)
        }else{
            logger.info("模拟器中无法打开照相机，请在真机上使用")
        }
    }
    
    //选取当地的照片，想要页面中为，在info。plist 中Localized resources can be mixed 为YES
    func localPhoto(){
        picker = UIImagePickerController()
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker!.allowsEditing = true
        picker!.delegate = self
        self.present(picker!, animated: true, completion: nil)
    }
    
    //选取图片之后
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        let type = info["UIImagePickerControllerMediaType"] as! NSString
        if(type.isEqual(to: "public.image")){
            
            let image = info["UIImagePickerControllerEditedImage"] as! UIImage
            
            //保存图片到本地沙盒
            let saveCache = SaveCacheDataModel()
            let result = saveCache.savaImageToChatCacheDir(contectorNickName, image: image, imageName: "BIM.png")
            if result {
                self.bimChanged()
            }
        }
        picker.dismiss(animated: true, completion: nil)
        self.picker = nil
    }
    
    func bimChanged(){
        
        //聊天的设置数据保存
        let chatsData = SaveDataModel()
        var chatSettingData = chatsData.loadChatSettingDataFromTempDirectory()
        
        //获得设置的置顶消息
        for i in 0 ..< chatSettingData.count{
            let data = chatSettingData[i]
            let nickname = data.nickname
            if nickname == contectorNickName{
                data.chatBIMPath = "BIM.png"
                
                chatSettingData.remove(at: i)
                chatSettingData.append(data)
                break
            }
        }
        chatsData.saveChatSettingToTempDirectory(settingData: chatSettingData)
    }
}
