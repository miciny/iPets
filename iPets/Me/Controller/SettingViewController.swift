//
//  SettingPageViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    fileprivate var mainTabelView: UITableView? //整个table
    fileprivate var infoData : NSMutableArray? //数据
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setData()
        setUpTable()
        // Do any additional setup after loading the view.
    }

    func setUpEles(){
        self.title = "设置"                        //页面title和底部title
        self.view.backgroundColor = UIColor.white //背景色
    }
    
    //footerView
    func setFooterView() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 120))
        footerView.backgroundColor = UIColor.clear
        
        let logOutBtn = UIButton(frame: CGRect(x: 0, y: 20, width: Width, height: 44))
        logOutBtn.backgroundColor = UIColor.white
        logOutBtn.setTitle("退出登录", for: UIControlState())
        logOutBtn.setTitleColor(UIColor.black, for: UIControlState())
        logOutBtn.layer.cornerRadius = 0
        logOutBtn.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        footerView.addSubview(logOutBtn)
        
        return footerView
    }
    
    @objc func logOut(){
        ToastView().showToast("HeHe")
    }
    
    func setData(){
        
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"] as! String as AnyObject
        let minorVersion : AnyObject? = infoDictionary! ["CFBundleVersion"] as! String as AnyObject
        
        let iosversion = UIDevice.current.systemVersion as String //系统版本号
        let appversion = majorVersion as! String //版本号
        let buildversion = minorVersion as! String  //构建号
        
        logger.info("app version: "+appversion)
        logger.info("build version: "+buildversion)
        logger.info("iOS version: "+iosversion)
        
        infoData = NSMutableArray()
        
        let infoOne1 = SettingDataModel(pic: nil, name: "帐号与安全", lable: "已保护")
        
        let infoTwo1 = SettingDataModel(pic: nil, name: "新消息通知", lable: nil)
        let infoTwo2 = SettingDataModel(pic: nil, name: "隐私", lable: nil)
        let infoTwo3 = SettingDataModel(pic: nil, name: "通用", lable: nil)
        
        let infoThree1 = SettingDataModel(pic: nil, name: "帮助与反馈", lable: nil)
        let infoThree2 = SettingDataModel(pic: nil, name: "关于我的爱宠", lable: appversion)
        
        infoData?.add([infoOne1])
        infoData?.add([infoTwo1, infoTwo2, infoTwo3])
        infoData?.add([infoThree1, infoThree2])
    }
    
    //设置tableView
    func setUpTable(){
        mainTabelView = UITableView(frame: self.view.frame, style: .grouped)  //为group模式
        mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        mainTabelView?.showsVerticalScrollIndicator = false
        mainTabelView?.showsHorizontalScrollIndicator = false
        mainTabelView?.sectionFooterHeight = 5
        mainTabelView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine //是否显示线条
        
        mainTabelView?.delegate = self
        mainTabelView?.dataSource = self
        
        mainTabelView?.tableFooterView = setFooterView()
        
        self.view.addSubview(mainTabelView!)
    }
    
    //section个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return infoData!.count
    }
    
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (infoData![section] as AnyObject).count
    }
    
    //计算每个cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section: [AnyObject]  =  self.infoData![indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row]
        let item =  data as! SettingDataModel
        let height  = item.height
        
        return height
    }
    
    //每个cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "SettingPageCell"
        let section : NSArray =  self.infoData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let cell =  SettingTableViewCell(data: data as! SettingDataModel, reuseIdentifier: cellId)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    //选择了row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabelView!.deselectRow(at: indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
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
                let commonPage = Setting_CommonFuncViewController()
                self.navigationController?.pushViewController(commonPage, animated: true)
                
            default:
                break
            }
        default:
            break
        }
    }
    
    
    //第一个section距离navigationbar的距离,第一个和第二个的间距设置，用mainTabelView?.sectionFooterHeight = 10，这个距离的计算是header的高度加上footer的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
