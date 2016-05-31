//
//  CommonFuncViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class CommonFuncViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        self.title = "通用"                        //页面title和底部title
        self.view.backgroundColor = UIColor.whiteColor() //背景色
    }
    
    //footerView
    func setFooterView() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 120))
        footerView.backgroundColor = UIColor.clearColor()
        
        let logOutBtn = UIButton(frame: CGRect(x: 0, y: 20, width: Width, height: 44))
        logOutBtn.backgroundColor = UIColor.whiteColor()
        logOutBtn.setTitle("清空记录", forState: .Normal)
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
        infoData = NSMutableArray()
        
        let infoOne1 = SettingPageModel(pic: nil, name: "多语言", lable: nil)
        
        let infoTwo1 = SettingPageModel(pic: nil, name: "字体大小", lable: nil)
        let infoTwo2 = SettingPageModel(pic: nil, name: "聊天背景", lable: nil)
        let infoTwo3 = SettingPageModel(pic: nil, name: "我的表情", lable: nil)
        
        let infoThree1 = SettingPageModel(pic: nil, name: "聊天记录迁移", lable: nil)
        let infoThree2 = SettingPageModel(pic: nil, name: "清里存储空间", lable: Cache.cacheSize)
        
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
            //语言
            case 0:
                break
                
            default:
                break
            }
        case 2:
            switch indexPath.row {
            //通用
            case 1:
                let wait = WaitView()
                wait.showWait("清除中")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{
                    Cache.clearCache()
                    dispatch_async(dispatch_get_main_queue(), {
                        wait.hideView()
                        self.setData()
                        self.mainTabelView?.reloadData()
                        ToastView().showToast("清除成功")
                    })
                })
                
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
