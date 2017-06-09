//
//  FindPetsViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class FindPetsViewController: UIViewController, isRefreshingDelegate, isLoadMoreDelegate, actionMenuViewDelegate, UITableViewDataSource, UITableViewDelegate{
    
    fileprivate var cellData: NSMutableArray?
    fileprivate var mainTableView: UITableView?
    fileprivate let cellID = "FindPetsCell"
    
    fileprivate var headerView: RefreshHeaderView? //自己写的
    fileprivate var footerView: LoadMoreView?
    
    //右上角添加按钮的事件
    fileprivate let addArray: NSDictionary = ["我要寻宠": "FindPets",
                                               "发布宠物踪迹": "PetsClue",
                                               "只看朋友": "OnlyFriends",
                                               "测试视频": "TestVideo"]
    fileprivate var addActionView: ActionMenuView?  //此处定义，方便显示和消失的判断
    fileprivate let limited = 10 //每次加载的数量
    fileprivate var deledeIndex = -1 //删除的index
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpEles()
        self.setUpTable()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.refreshData()
    }
    
    //退出界面，菜单消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if addActionView != nil {
            addActionView?.hideView()
        }
        VideoFuncs.viewWillDisappearStopVideo() //停止视频
    }
    
    //初始化title 背景等
    func setUpEles(){
        self.title = "附近寻宠"                           //页面title和底部title
        self.view.backgroundColor = UIColor.white //背景色
        
        //右上角添加按钮
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.addButtonClicked))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    func addButtonClicked(){
        if(addActionView?.superview == nil){
            addActionView = ActionMenuView(object: addArray, center: CGPoint(x: Width, y: navigateBarHeight+90), target: self, showInView: self.view)
            addActionView!.eventFlag = 1 //可以不设置，默认为0，方便一个页面多次调用
        }else{
            addActionView?.hideView()
            addActionView?.removeFromSuperview()
        }
    }
    
//======================================一些代理方法================================
    //actionMenuView的代理方法
    func menuClicked(_ tag: Int, eventFlag: Int) {
        switch eventFlag{
        case 1:
            switch tag{
            //我要寻宠页
            case 0:
                let sendFindMyPetsInfoVc = SendFindMyPetsInfoViewController()
                let sendFindMyPetsInfoVcNavigationController = UINavigationController(rootViewController: sendFindMyPetsInfoVc) //带导航栏
                self.navigationController?.present(sendFindMyPetsInfoVcNavigationController, animated: true, completion: nil)
            case 1:
                ToastView().showToast(addArray.allKeys[1] as! String)
            case 2:
                ToastView().showToast(addArray.allKeys[2] as! String)
            case 3:
                self.testVideo()
            default:
                break
            }
        default:
            break
        }
    }
    
    func testVideo(){
        
        let time = Date()
        //提取原来的寻宠数据
        let findMyPetsData = SaveDataModel()
        var oldData = findMyPetsData.loadFindMyPetsDataFromTempDirectory()
        
        let myFindPetsInfo = FindPetsCellModel(name: myInfo.username!, text: nil, picture: nil, date: time, nickname: myInfo.nickname!, video: "ddd", from: .me)
        
        oldData.append(myFindPetsInfo)
        
        //保存寻宠数据
        findMyPetsData.saveFindMyPetsToTempDirectory(oldData)
        
        self.refreshData()
    }
    
    //isLoadMore中的代理方法
    func loadingMore(){
        mainTableView!.setContentOffset(CGPoint(x: 0, y: mainTableView!.contentSize.height - mainTableView!.frame.size.height+tabBarHeight+RefreshHeaderHeight), animated: true)
        //这里做你想做的事
        let _ = delay(0.3){
            self.loadMoreData()
            
            self.footerView!.endRefresh()
            self.footerView!.hideView()
            
        }

    }
    
    //isfreshing中的代理方法
    func reFreshing(){
        
        self.refreshData()
        
        //这里做你想做的事
        let _ = delay(0.5){
            self.headerView?.endRefresh()
            ToastView().showToast("刷新完成！")
        }
    }
    
//======================================tableView================================
    //tableView部分
    
    func setUpTable(){
        mainTableView = UITableView()
        cellData = NSMutableArray()
        
        mainTableView!.frame = CGRect(x: 0, y: 0, width: Width, height: Height) //49为tabbar高度
        mainTableView!.delegate = self
        mainTableView!.dataSource = self
        mainTableView!.backgroundColor = UIColor.white
        self.view.addSubview(mainTableView!)
        
        //注册cell
        let cell = FindPetsTableViewCell.self
        mainTableView!.register(cell, forCellReuseIdentifier: cellID)
        
        headerView = RefreshHeaderView(subView: mainTableView!, target: self)  //添加下拉刷新
    }
    
    //加载更多数据
    func loadMoreData(){
        
        let cellDataTemp = NSMutableArray() //保存从数据库读取的［FindPetsCellModel］
        let cellDataCount = cellData!.count
        //读取数据
        let findMyPetsData = SaveDataModel()
        cellDataTemp.addObjects(from: findMyPetsData.loadFindMyPetsDataFromTempDirectory())
        
        //加载更多的三种情况
        if cellDataTemp.count <= cellDataCount{
            ToastView().showToast("无更多数据")
            mainTableView!.setContentOffset(CGPoint(x: 0, y: mainTableView!.contentSize.height - mainTableView!.frame.size.height+tabBarHeight), animated: true)
        }else if cellDataTemp.count-cellDataCount > limited{
            self.sortDate(data: cellDataTemp)  //那 mutableArray用这个方法
            
            //将FindPetsCellModel 转为FindPetsCellFrameModel
            for i in cellDataCount ..< cellDataCount+limited{
                let frame = FindPetsCellFrameModel()
                frame.setCellModel(cellDataTemp[i] as! FindPetsCellModel)
                cellData?.add(frame)
            }
            ToastView().showToast("加载完成！")
        }else{
            self.sortDate(data: cellDataTemp)  //那 mutableArray用这个方法
            
            //将FindPetsCellModel 转为FindPetsCellFrameModel
            for i in cellDataCount ..< cellDataTemp.count{
                let frame = FindPetsCellFrameModel()
                frame.setCellModel(cellDataTemp[i] as! FindPetsCellModel)
                cellData?.add(frame)
            }
            ToastView().showToast("加载完成！")
        }
        
        self.mainTableView!.reloadData()
    }
    
    //刷新数据
    func refreshData(){
        cellData?.removeAllObjects()
        
        let cellDataTemp = NSMutableArray() //保存从数据库读取的［FindPetsCellModel］
        //读取数据
        let findMyPetsData = SaveDataModel()
        cellDataTemp.addObjects(from: findMyPetsData.loadFindMyPetsDataFromTempDirectory())
        
        guard cellDataTemp.count > 0 else{
            self.mainTableView!.tableFooterView = UIView(frame: CGRect.zero)
            return
        }
        
        if cellDataTemp.count <= limited{
            self.sortDate(data: cellDataTemp)  //那 mutableArray用这个方法
            
            //将FindPetsCellModel 转为FindPetsCellFrameModel
            for i in 0 ..< cellDataTemp.count{
                let frame = FindPetsCellFrameModel()
                frame.setCellModel(cellDataTemp[i] as! FindPetsCellModel)
                cellData?.add(frame)
            }
        }else{
            self.sortDate(data: cellDataTemp)   //那 mutableArray用这个方法
            //将FindPetsCellModel 转为FindPetsCellFrameModel
            for i in 0 ..< limited{
                let frame = FindPetsCellFrameModel()
                frame.setCellModel(cellDataTemp[i] as! FindPetsCellModel)
                cellData?.add(frame)
            }
        }
        
        self.mainTableView!.reloadData()
        
        //没有数据，就显示footer
        if cellData?.count == 0 {
            self.mainTableView?.tableFooterView = setFooterView()
            self.mainTableView?.tableFooterView?.isHidden = false
        }else{
            self.mainTableView?.tableFooterView?.isHidden = true
        }
    }
    
    //footerView
    func setFooterView() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 120))
        footerView.backgroundColor = UIColor.clear
        
        let logOutBtn = UIButton(frame: CGRect(x: 20, y: 100, width: Width-44, height: 44))
        logOutBtn.backgroundColor = UIColor.white
        logOutBtn.setTitle("无数据", for: UIControlState())
        logOutBtn.setTitleColor(UIColor.black, for: UIControlState())
        logOutBtn.layer.cornerRadius = 5
        footerView.addSubview(logOutBtn)
        
        return footerView
    }
    
    //排序
    func sortDate(data: NSMutableArray) {
        data.sort(comparator: { (m1, m2) -> ComparisonResult in
            if((m1 as! FindPetsCellModel).date.timeIntervalSince1970 > (m2 as! FindPetsCellModel).date.timeIntervalSince1970){
                return ComparisonResult.orderedAscending
            }else{
                return ComparisonResult.orderedDescending
            }
        })
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cellData!.count
    }
    
    //cell显示的内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FindPetsTableViewCell
        cell.delegate = self
        
        //清空
        for subViews in cell.subviews{
            subViews.removeFromSuperview()
        }
        
        cell.showCellWithModel(self.cellData![indexPath.row] as! FindPetsCellFrameModel, indexPath: indexPath) //处理显示数据的大小高度问题
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //设置删除
        if let delete = cell.deleteView{
            delete.tag = indexPath.row
            delete.addTarget(self, action: #selector(deleteFindPets(_:)), for: .touchUpInside)
        }
        
        //设置more
        cell.moreView.tag = indexPath.row
        cell.moreView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(moreFindPets(_:)))
        cell.moreView.addGestureRecognizer(tap)
        
        return cell
    }
    
    //more按钮
    func moreFindPets(_ sender: UITapGestureRecognizer){
        let more = sender.view
        ToastView().showToast(String(describing: more?.tag))
    }
    
    //删除按钮
    func deleteFindPets(_ sender: UIButton){
        deledeIndex = sender.tag
        let deleteAlertView = UIAlertController(title: "您确定要删除吗？", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler:{
            
            (UIAlertAction) -> Void in
            //先删除cellData
            self.cellData?.removeObject(at: self.deledeIndex)
            self.mainTableView?.reloadData()
            
            //删plist 删图片
            self.deletePlistData()
            
            if self.cellData?.count == 0 {
                self.refreshData()
            }
            
            ToastView().showToast("删除成功")
        })
        
        deleteAlertView.addAction(cancelAction)
        deleteAlertView.addAction(okAction)// 当添加的UIAlertAction超过两个的时候，会自动变成纵向分布
        self.present(deleteAlertView, animated: true, completion: nil)
    }
    
    //删plist
    func deletePlistData(){
        //提取原来的寻宠数据
        let findMyPetsData = SaveDataModel()
        let oldData = NSMutableArray()
        oldData.addObjects(from: findMyPetsData.loadFindMyPetsDataFromTempDirectory())
        self.sortDate(data: oldData)
        
        //获取图片数组
        let singleData = oldData.object(at: deledeIndex) as! FindPetsCellModel
        let imageName = singleData.picture
        if imageName != nil {
            let deleteImageData = SaveCacheDataModel()
            deleteImageData.deleteImageFromFindPetsCacheDir(imageName!)
        }
        
        oldData.removeObject(at: deledeIndex)
        
        let newData = oldData as NSArray
        //保存寻宠数据
        findMyPetsData.saveFindMyPetsToTempDirectory(newData as! [FindPetsCellModel])
        
    }
    
    //计算高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellFrame  = self.cellData![indexPath.row] as! FindPetsCellFrameModel
        return cellFrame.cellHeight
    }
    
    //结束cell
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell滑出屏幕时，结束播放
        VideoFuncs.cellWillDisappearStopVideo(indexPath)
    }
    
    //此处添加footerView，方便找到contentSize的高度
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        //如果不足一屏幕，不显示footer
        if(self.mainTableView!.contentSize.height <= self.mainTableView!.frame.height){
            self.mainTableView!.tableFooterView = UIView(frame: CGRect.zero)
            return
        }
        
        if(footerView == nil && indexPath.row == self.cellData!.count-1 ){
            footerView = LoadMoreView(frame: mainTableView!.frame, subView: mainTableView!, target: self)
        }
        
        if(indexPath.row == self.cellData!.count-1 ){
            footerView?.refreshHeight()
            footerView?.showView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FindPetsViewController: FindPetsCellViewDelegate{
    
    func showPic(_ pic: [UIImage], index: Int, frame: [CGRect]) {
        let picView = PicsBrowserView()
        picView.setUpAllFramePicBrowser(pic, index: index, frame: frame)
    }
    
    func pushToPersonInfoView(name: String){
        let guestContectorVC = ContectorInfoViewController()
        guestContectorVC.contectorName = name
        guestContectorVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(guestContectorVC, animated: true)
    }
}
