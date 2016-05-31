//
//  SettingViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var mainTabelView: UITableView? //整个table
    private var settingData : NSMutableArray? //数据
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setData()
        setUpTable()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setData()
        mainTabelView?.reloadData()
    }
    
    func setUpEles(){
        self.title = "我"                        //页面title和底部title
        self.navigationItem.title = "我"        //再次设置顶部title,这样才可以和tabbar上的title不一样
        self.view.backgroundColor = UIColor.whiteColor() //背景色
    }
    
    func setData(){
        settingData = NSMutableArray()
        
        let settingOne = SettingDataModel(pic: myInfo.icon!, name: myInfo.username!, nickname: myInfo.nickname!, TDicon: "TDicon")
        let settingTwoOne = SettingDataModel(icon: "collection.png", lable: "收藏")
        let settingTwoTwo = SettingDataModel(icon: "RichScan", lable: "扫一扫")
        let settingTwoThree = SettingDataModel(icon: "shake", lable: "摇一摇")
        let settingThree = SettingDataModel(icon: "setting", lable: "设置")
        
        settingData?.addObject([settingOne])
        settingData?.addObject([settingTwoOne, settingTwoTwo, settingTwoThree])
        settingData?.addObject([settingThree])
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
        
        self.view.addSubview(mainTabelView!)
    }
    
    //section个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return settingData!.count
    }
    
    //每个section的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingData![section].count
    }
    
    //计算每个cell高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section: [AnyObject]  =  self.settingData![indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row]
        let item =  data as! SettingDataModel
        let height  = item.view.frame.height
        
        return height
    }
    
    //每个cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "SettingCell"
        let section : NSArray =  self.settingData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let cell =  SettingTableViewCell(data:data as! SettingDataModel, reuseIdentifier:cellId)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator  //显示后面的小箭头

        return cell
    }
    
    //选择了row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mainTabelView!.deselectRowAtIndexPath(indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        switch indexPath.section{
        //进入个人信息页
        case 0:
            switch indexPath.row {
            //个人信息页
            case 0:
                let infoVc = PersonInfoViewController()
                infoVc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(infoVc, animated: true)
                
            default:
                break
            }
            
        //第二个设置栏
        case 1:
            switch indexPath.row {
            //扫一扫
            case 1:
                let TDCodeVc = TDCodeViewController()
                TDCodeVc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(TDCodeVc, animated: true)
                
            case 0: //测试添加联系人

                let aa = SQLLine.SelectAllData(entityNameOfContectors)
                if(aa.count > 0){
                    ToastView().showToast("已添加")
                    return
                }
                
                let defaultIcon = UIImage(named: "defaultIcon")
                let defaultIconData = UIImagePNGRepresentation(defaultIcon!)
                let str = "毛彩元历史元我们的生活就是饿着么一个人的啊你不懂吗我就知道他晕了"
                
                for i in 0 ..< str.characters.count-1{
                    let strs = (str as NSString).substringWithRange(NSMakeRange(i, 2))
                    SQLLine.InsertContectorsData(strs, icon: defaultIconData!, nickname: "haha \(strs)", sex: strs, remark: "my heart \(strs)", address: "中国\(strs)", http: "www.baidu.com\(strs)")
                }
                
                ToastView().showToast("添加成功")
                
            default:
                break
            }
            
        //设置
        case 2:
            switch indexPath.row {
            case 0: //设置
                let settingPage = SettingPageViewController()
                settingPage.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(settingPage, animated: true)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
