//
//  PersonInfoViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class PersonInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    private var mainTabelView: UITableView? //整个table
    private var infoData : NSMutableArray? //数据
    private var infoCoreData : NSMutableArray? //从数据读取的个人信息组

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setData()
        setUpTable()
        
    }
    
    func setUpEles(){
        self.title = "个人信息"                        //页面title和底部title
        self.view.backgroundColor = UIColor.whiteColor() //背景色
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setData()
        mainTabelView?.reloadData()
    }
    
    func setData(){
        infoData = NSMutableArray()
        
        //从CoreData里读取数据
        let SettingDataArray = SQLLine.SelectAllData(entityNameOfSettingData)
        
        var sex = ""
        var address = ""
        var motto = ""
        
        //如果有数据，就读取数据
        if(SettingDataArray.count > 0){
            sex = SettingDataArray.lastObject!.valueForKey(settingDataNameOfMySex)! as! String
            address = SettingDataArray.lastObject!.valueForKey(settingDataNameOfMyAddress)! as! String
            motto = SettingDataArray.lastObject!.valueForKey(settingDataNameOfMyMotto)! as! String
        }
        
        let infoOne1 = PersonInfoModel(pic: myInfo.icon!, name: "头像")
        let infoOne2 = PersonInfoModel(lable: myInfo.username!, name: "名字")
        let infoOne3 = PersonInfoModel(lable: myInfo.nickname!, name: "寻宠号")
        let infoOne4 = PersonInfoModel(TDicon: "TDicon", name: "我的二维码")
        let infoOne5 = PersonInfoModel(lable: "西小口", name: "我的地址")
        
        let infoTwo1 = PersonInfoModel(lable: sex, name: "性别")
        let infoTwo2 = PersonInfoModel(lable: address, name: "地区")
        let infoTwo3 = PersonInfoModel(lable: motto, name: "个性签名")
        
        infoData?.addObject([infoOne1, infoOne2, infoOne3, infoOne4, infoOne5])
        infoData?.addObject([infoTwo1, infoTwo2, infoTwo3])
    }
    
    //设置tableView
    func setUpTable(){
        mainTabelView = UITableView(frame: self.view.frame, style: .Grouped)  //为group模式
        mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        mainTabelView?.showsVerticalScrollIndicator = false
        mainTabelView?.showsHorizontalScrollIndicator = false
        mainTabelView?.sectionFooterHeight = 5
        mainTabelView?.separatorStyle = UITableViewCellSeparatorStyle.SingleLine //是否显示线条
        
        mainTabelView?.delegate = self
        mainTabelView?.dataSource = self
        
        self.view.addSubview(mainTabelView!)
    }
    
    //section个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return infoData!.count
    }
    
    //每个section的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoData![section].count
    }
    
    //计算每个cell高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section: [AnyObject]  =  self.infoData![indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row]
        let item =  data as! PersonInfoModel
        let height  = item.view.frame.height
        
        return height
    }
    
    //每个cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "InfoCell"
        let section : NSArray =  self.infoData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let cell =  PersonInfoTableViewCell(data: data as! PersonInfoModel, reuseIdentifier: cellId)
        //寻宠好不能变
        if indexPath.section != 0 || indexPath.row != 2 {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        return cell
    }
    
    //选择了row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mainTabelView!.deselectRowAtIndexPath(indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        //提取cell的数据
        let section : NSArray =  self.infoData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let item = data as! PersonInfoModel
        
        switch indexPath.section{
        case 0:
            switch indexPath.row {
            
            //头像页
            case 0:
                let myIconVc = MyIconViewController()
                myIconVc.image = item.pic
                self.navigationController?.pushViewController(myIconVc, animated: true)
                
            //名字页
            case 1:
                let myNameVc = PersonInfoChangeNameViewController()
                myNameVc.name = item.lable
                self.navigationController?.pushViewController(myNameVc, animated: true)
                
            //二维码页
            case 3:
                let myTDIcon = MyTDCodeImageViewController()
                self.navigationController?.pushViewController(myTDIcon, animated: true)
                
            default:
                break
            }
        default:
            break
        }
    }
    
    //第一个section距离navigationbar的距离,第一个和第二个的间距设置，用mainTabelView?.sectionFooterHeight = 10，这个距离的计算是header的高度加上footer的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
