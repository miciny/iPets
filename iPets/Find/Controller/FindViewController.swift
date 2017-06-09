//
//  FindViewController.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/9.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class FindViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    fileprivate var mainTabelView: UITableView? //整个table
    fileprivate var findData: NSMutableArray? //数据
    
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
        self.title = "发现"                        //页面title和底部title
        self.navigationItem.title = "发现"        //再次设置顶部title,这样才可以和tabbar上的title不一样
        self.view.backgroundColor = UIColor.white //背景色
    }
    
    func setData(){
        findData = NSMutableArray()
        
        let oneOne = FindDataModel(icon: "collection.png", title: "附近寻宠")
        let twoOne = FindDataModel(icon: "RichScan", title: "热点新闻")
        let twoTwo = FindDataModel(icon: "shake", title: "热点视频")
        
        findData!.add([oneOne])
        findData!.add([twoOne, twoTwo])
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
        return findData!.count
    }
    
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (findData![section] as AnyObject).count
    }
    
    //计算每个cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.findData![indexPath.section] as! [AnyObject] //获取section里的对象
        let data = section[indexPath.row]
        let item =  data as! FindDataModel
        let height = item.height
        
        return height
    }
    
    //每个cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "FindCell"
        let section : NSArray =  self.findData![indexPath.section] as! NSArray
        let data = section[indexPath.row]
        let cell =  FindTableViewCell(data: data as! FindDataModel, reuseIdentifier: cellID)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator  //显示后面的小箭头
        
        return cell
    }
    
    //选择了row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabelView!.deselectRow(at: indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        switch indexPath.section{
            
        case 0:
            switch indexPath.row {
            //附近寻宠
            case 0:
                let vc = FindPetsViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            default:
                break
            }
        
        case 1:
            switch indexPath.row {
            //视频
            case 1:
                let vc = VideoViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            //新闻
            case 0:
                let vc = NewsRootViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
