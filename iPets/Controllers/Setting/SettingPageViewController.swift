//
//  SettingPageViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SettingPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    private var mainTabelView: UITableView? //整个table
    private var infoData : NSMutableArray? //数据
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setData()
        setUpTable()
        // Do any additional setup after loading the view.
    }

    func setUpEles(){
        self.title = "设置"                        //页面title和底部title
        self.view.backgroundColor = UIColor.whiteColor() //背景色
    }
    
    //footerView
    func setFooterView() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 120))
        footerView.backgroundColor = UIColor.clearColor()
        
        let logOutBtn = UIButton(frame: CGRect(x: 0, y: 20, width: Width, height: 44))
        logOutBtn.backgroundColor = UIColor.whiteColor()
        logOutBtn.setTitle("退出登录", forState: .Normal)
        logOutBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        logOutBtn.layer.cornerRadius = 0
        logOutBtn.addTarget(self, action: #selector(logOut), forControlEvents: .TouchUpInside)
        footerView.addSubview(logOutBtn)
        
        return footerView
    }
    
    func logOut(){
        ToastView().showToast("HeHe")
    }
    
    func setData(){
        
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"] as! String
        let minorVersion : AnyObject? = infoDictionary! ["CFBundleVersion"] as! String
        let iosversion : NSString = UIDevice.currentDevice().systemVersion;
        
        let appversion = majorVersion as! String
        let buildversion = minorVersion as! String
        
        print(appversion)
        print(buildversion)
        print(iosversion)
        
        infoData = NSMutableArray()
        
        let infoOne1 = SettingPageModel(pic: nil, name: "帐号与安全", lable: "已保护")
        
        let infoTwo1 = SettingPageModel(pic: nil, name: "新消息通知", lable: nil)
        let infoTwo2 = SettingPageModel(pic: nil, name: "隐私", lable: nil)
        let infoTwo3 = SettingPageModel(pic: nil, name: "通用", lable: nil)
        
        let infoThree1 = SettingPageModel(pic: nil, name: "帮助与反馈", lable: nil)
        let infoThree2 = SettingPageModel(pic: nil, name: "关于我的爱宠", lable: appversion)
        
        infoData?.addObject([infoOne1])
        infoData?.addObject([infoTwo1, infoTwo2, infoTwo3])
        infoData?.addObject([infoThree1, infoThree2])
        
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
        
        mainTabelView?.tableFooterView = setFooterView()
        
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
        let item =  data as! SettingPageModel
        let height  = item.view.frame.height
        
        return height
    }
    
    //每个cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "SettingPageCell"
        let section : NSArray =  self.infoData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let cell =  SettingPageTableViewCell(data:data as! SettingPageModel, reuseIdentifier:cellId)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    //选择了row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mainTabelView!.deselectRowAtIndexPath(indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        switch indexPath.section{
        case 0:
            switch indexPath.row {
            //帐号
            case 0:
                break
                
            default:
                break
            }
        case 1:
            switch indexPath.row {
            //通用
            case 2:
                let commonPage = CommonFuncViewController()
                self.navigationController?.pushViewController(commonPage, animated: true)
                
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
