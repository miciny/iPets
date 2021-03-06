//
//  SettingViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    fileprivate var mainTabelView: UITableView? //整个table
    fileprivate var settingData: NSMutableArray? //数据
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setData()
        setUpTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setData()
        mainTabelView?.reloadData()
    }
    
    func setUpEles(){
        self.title = "我"                        //页面title和底部title
        self.navigationItem.title = "我"        //再次设置顶部title,这样才可以和tabbar上的title不一样
        self.view.backgroundColor = UIColor.white //背景色
    }
    
    func setData(){
        settingData = NSMutableArray()
        
        let settingOne = MeDataModel(pic: myInfo.icon!, name: myInfo.username!, nickname: myInfo.nickname!, TDicon: "TDicon")
        
        let settingTwoOne = MeDataModel(icon: "MoneyPackt", lable: "钱包")
        
        let settingThreeOne = MeDataModel(icon: "collection.png", lable: "收藏(测试联系人)")
        let settingThreeTwo = MeDataModel(icon: "EMotion", lable: "表情")
        let settingThreeThree = MeDataModel(icon: "MoreMyAlbum", lable: "相册")
        
        let settingFourOne = MeDataModel(icon: "setting", lable: "设置")
        
        settingData?.add([settingOne])
        settingData?.add([settingTwoOne])
        settingData?.add([settingThreeOne, settingThreeTwo, settingThreeThree])
        settingData?.add([settingFourOne])
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
    
    //section个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingData!.count
    }
    
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (settingData![section] as AnyObject).count
    }
    
    //计算每个cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section: [AnyObject]  =  self.settingData![indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row]
        let item =  data as! MeDataModel
        let height  = item.height
        
        return height
    }
    
    //每个cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "SettingCell"
        let section : NSArray =  self.settingData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let cell =  MeViewCell(data:data as! MeDataModel, reuseIdentifier: cellID)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator  //显示后面的小箭头

        return cell
    }
    
    //选择了row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabelView!.deselectRow(at: indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
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
            
        case 1:
            switch indexPath.row {
            //钱包
            case 0:
                break
                
            default:
                break
            }
            
        //设置栏
        case 2:
            switch indexPath.row {
                
            //表情
            case 1:
                break
                
            // 收藏 测试添加联系人
            case 0:

                let aa = SQLLine.SelectAllData(entityNameOfContectors)
                if(aa.count > 1){
                    ToastView().showToast("已添加")
                    return
                }
                
                let defaultIcon = UIImage(named: "defaultIcon")
                let defaultIconData = UIImagePNGRepresentation(defaultIcon!)
                let str = "毛彩元历史元我们的生活就是饿着么一个人的啊你不懂吗我就知道他晕了"
                
                for i in 0 ..< str.count-1{
                    let strs = (str as NSString).substring(with: NSMakeRange(i, 2))
                    let _ = SQLLine.InsertContectorsData(strs, icon: defaultIconData!, nickname: "haha \(strs)", sex: strs, remark: "my heart \(strs)", address: "中国\(strs)", http: "www.baidu.com\(strs)")
                }
                
                ToastView().showToast("添加成功")
                
            //相册
            case 2:
                break
                
            default:
                break
            }
            
        //设置
        case 3:
            switch indexPath.row {
            case 0: //设置
                let settingPage = SettingViewController()
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
