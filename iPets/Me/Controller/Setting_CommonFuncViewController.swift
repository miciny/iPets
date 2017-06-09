//
//  CommonFuncViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Kingfisher

class Setting_CommonFuncViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    fileprivate var mainTabelView: UITableView? //整个table
    fileprivate var infoData : NSMutableArray? //数据
    fileprivate var isClaculatingCache: Bool? //是否在计算
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setData()
        setUpTable()
        setCacheData()
        // Do any additional setup after loading the view.
    }
    
    func setUpEles(){
        self.title = "通用"                        //页面title和底部title
        self.view.backgroundColor = UIColor.white //背景色
    }
    
    //footerView
    func setFooterView() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 120))
        footerView.backgroundColor = UIColor.clear
        
        let logOutBtn = UIButton(frame: CGRect(x: 0, y: 20, width: Width, height: 44))
        logOutBtn.backgroundColor = UIColor.white
        logOutBtn.setTitle("清空记录", for: UIControlState())
        logOutBtn.setTitleColor(UIColor.black, for: UIControlState())
        logOutBtn.layer.cornerRadius = 0
        logOutBtn.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        footerView.addSubview(logOutBtn)
        
        return footerView
    }
    
    func logOut(){
        ToastView().showToast("HeHe")
    }
    
    func setData(){
        infoData = NSMutableArray()
        
        let infoOne1 = SettingDataModel(pic: nil, name: "多语言", lable: nil)
        
        let infoTwo1 = SettingDataModel(pic: nil, name: "字体大小", lable: nil)
        let infoTwo2 = SettingDataModel(pic: nil, name: "聊天背景", lable: nil)
        let infoTwo3 = SettingDataModel(pic: nil, name: "我的表情", lable: nil)
        
        let infoThree1 = SettingDataModel(pic: nil, name: "聊天记录迁移", lable: nil)
        let infoThree2 = SettingDataModel(pic: nil, name: "清里存储空间", lable: "0.0MB")
        
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
                globalQueue.async(execute: {
                    
                    let _ = Cache.clearCache()
                    
                    mainQueue.async(execute: {
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//===========================================缓存======================================
    
    func setCacheData(){
        self.isClaculatingCache = true
        
        getLocalCache { (myCache) in
            let CalculateQueue = DispatchQueue(label: "CalculateQueue", attributes: [])
            CalculateQueue.async {
                let indexPath = IndexPath(item: 1, section: 2)
                let allSize = myCache  //本地缓存加kingfisher的缓存
                let cacheSizeStr = NSString(format: "%.2fMB", allSize) as String
                let section = self.infoData![indexPath.section] as! [AnyObject]
                let data = section[indexPath.row] as! SettingDataModel
                
                data.lable = cacheSizeStr
                mainQueue.async(execute: {
                    self.mainTabelView!.reloadRows(at: [indexPath], with: .none)
                    self.isClaculatingCache = false
                })
            }
        }
    }
    
    //获取本地,因为kinfisher, WebKit 也把缓存放到缓存目录了
    func getLocalCache(_ completeHander: @escaping (Float) -> ()){
        let CalculateLocalQueue = DispatchQueue(label: "CalculateLocalQueue", attributes: [])
        CalculateLocalQueue.async {
            let myCache = Cache.cacheSize //本地缓存
            mainQueue.async(execute: {
                completeHander(myCache)
            })
        }
    }
    
    
    //清除缓存
    func clearCache(){
        let wait = WaitView()
        wait.showWait("清除中")
        
        //清除本地缓存
        if Cache.clearCache(){
            let imageCache = KingfisherManager.shared.cache
            //清理内存缓存
            imageCache.clearMemoryCache()
            imageCache.cleanExpiredDiskCache()
            
            // 清理硬盘缓存，这是一个异步的操作
            imageCache.clearDiskCache(completion: {
                wait.hideView()
                self.setCacheData()
                ToastView().showToast("清除成功")
            })
        }else{
            let toast = ToastView()
            toast.showToast("清除失败！")
        }
    }
}
