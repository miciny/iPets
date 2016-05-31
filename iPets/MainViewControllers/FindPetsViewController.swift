//
//  FindPetsViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class FindPetsViewController: UIViewController, isRefreshingDelegate, UIAlertViewDelegate, isLoadMoreingDelegate, actionMenuViewDelegate, UITableViewDataSource, UITableViewDelegate{
    
    private var cellData: NSMutableArray?
    private var mainTableView: UITableView?
    private let cellID = "FindPetsCell"
    
    private var headerView: RefreshHeaderView? //自己写的
    private var footerView: LoadMoreView?
    private let picView = FindPetsPicView() //展示图片的
    
    //右上角添加按钮的事件
    private let addArray : NSDictionary = ["我要寻宠":"FindPets", "发布宠物踪迹":"PetsClue","只看朋友":"OnlyFriends"]
    private var addActionView: ActionMenuView?  //此处定义，方便显示和消失的判断
    private let limited = 10 //每次加载的数量
    private var deledeIndex = -1 //删除的index
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setUpTable()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        refreshData()
    }
    
    //退出界面，菜单消失
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        if addActionView != nil {
            addActionView?.hideView()
        }
    }
    
    //初始化title 背景等
    func setUpEles(){
        self.title = "寻宠"                           //页面title和底部title
        self.navigationItem.title = "附近寻宠信息"        //再次设置顶部title,这样才可以和tabbar上的title不一样
        self.view.backgroundColor = UIColor.whiteColor() //背景色
        
        //右上角添加按钮
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(FindPetsViewController.addButtonClicked))
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
    
    //actionMenuView的代理方法
    func menuClicked(tag: Int, eventFlag: Int) {
        switch eventFlag{
        case 1:
            switch tag{
            //我要寻宠页
            case 0:
                let sendFindMyPetsInfoVc = SendFindMyPetsInfoViewController()
                let sendFindMyPetsInfoVcNavigationController = UINavigationController(rootViewController: sendFindMyPetsInfoVc) //带导航栏
                self.navigationController?.presentViewController(sendFindMyPetsInfoVcNavigationController, animated: true, completion: nil)
            case 1:
                ToastView().showToast(addArray.allKeys[1] as! String)
            case 2:
                ToastView().showToast(addArray.allKeys[2] as! String)
            default:
                break
            }
        default:
            break
        }
    }
    
    //isLoadMore中的代理方法
    func loadMore(){
        
        mainTableView!.setContentOffset(CGPointMake(0, mainTableView!.contentSize.height - mainTableView!.frame.size.height+tabBarHeight+RefreshHeaderHeight), animated: true)
        //这里做你想做的事
        delay(0.3){
            self.loadMoreData()
            
            self.footerView!.endRefresh()
            self.footerView!.hideView()
            
        }

    }
    
    //isfreshing中的代理方法
    func reFreshing(){
        
        mainTableView!.setContentOffset(CGPointMake(0, -RefreshHeaderHeight*2), animated: true)
        mainTableView!.scrollEnabled = false
        //这里做你想做的事
        delay(0.5){
            self.mainTableView!.scrollEnabled = true
            self.refreshData()
            if(self.cellData?.count > 0){
               self.mainTableView!.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition:UITableViewScrollPosition.Top, animated:true)
            }else{
                self.mainTableView!.setContentOffset(CGPointMake(0, -RefreshHeaderHeight), animated: true)
            }
            
            self.headerView?.endRefresh()
            ToastView().showToast("刷新完成！")
            
        }
        
    }
    
    //tableView部分
    
    func setUpTable(){
        mainTableView = UITableView()
        cellData = NSMutableArray()
        
        mainTableView!.frame = CGRect(x: 0, y: 0, width: Width, height: Height) //49为tabbar高度
        mainTableView!.delegate = self
        mainTableView!.dataSource = self
        mainTableView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(mainTableView!)
        
        //注册cell
        let cell = FindPetsCellTableViewCell.self
        mainTableView!.registerClass(cell, forCellReuseIdentifier: cellID)
        
        headerView =  RefreshHeaderView(frame: mainTableView!.frame, subView: mainTableView!, target: self)  //添加下拉刷新
    }
    
    //加载更多数据
    func loadMoreData(){
        
        let cellDataTemp = NSMutableArray() //保存从数据库读取的［FindPetsCellModel］
        let cellDataCount = cellData?.count
        //读取数据
        let findMyPetsData = SaveDataModel()
        cellDataTemp.addObjectsFromArray(findMyPetsData.loadFindMyPetsDataFromTempDirectory())
        
        //加载更多的三种情况
        if cellDataTemp.count <= cellDataCount{
            ToastView().showToast("无更多数据")
            mainTableView!.setContentOffset(CGPointMake(0, mainTableView!.contentSize.height - mainTableView!.frame.size.height+tabBarHeight), animated: true)
        }else if cellDataTemp.count-cellDataCount! > limited{
            cellDataTemp.sortUsingComparator(sortDate)  //那 mutableArray用这个方法
            
            //将FindPetsCellModel 转为FindPetsCellFrameModel
            for i in cellDataCount! ..< cellDataCount!+limited{
                let frame = FindPetsCellFrameModel()
                frame.setCellModel(cellDataTemp[i] as! FindPetsCellModel)
                cellData?.addObject(frame)
            }
            ToastView().showToast("加载完成！")
        }else{
            cellDataTemp.sortUsingComparator(sortDate)  //那 mutableArray用这个方法
            
            //将FindPetsCellModel 转为FindPetsCellFrameModel
            for i in cellDataCount! ..< cellDataTemp.count{
                let frame = FindPetsCellFrameModel()
                frame.setCellModel(cellDataTemp[i] as! FindPetsCellModel)
                cellData?.addObject(frame)
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
        cellDataTemp.addObjectsFromArray(findMyPetsData.loadFindMyPetsDataFromTempDirectory())
        
        if cellDataTemp.count <= limited{
            cellDataTemp.sortUsingComparator(sortDate)  //那 mutableArray用这个方法
            
            //将FindPetsCellModel 转为FindPetsCellFrameModel
            for i in 0 ..< cellDataTemp.count{
                let frame = FindPetsCellFrameModel()
                frame.setCellModel(cellDataTemp[i] as! FindPetsCellModel)
                cellData?.addObject(frame)
            }
        }else{
            cellDataTemp.sortUsingComparator(sortDate)  //那 mutableArray用这个方法
            
            //将FindPetsCellModel 转为FindPetsCellFrameModel
            for i in 0 ..< limited{
                let frame = FindPetsCellFrameModel()
                frame.setCellModel(cellDataTemp[i] as! FindPetsCellModel)
                cellData?.addObject(frame)
            }
        }
        
        self.mainTableView!.reloadData()
        
        //没有数据，就显示footer
        if cellData?.count == 0 {
            self.mainTableView?.tableFooterView = setFooterView()
            self.mainTableView?.tableFooterView?.hidden = false
        }else{
            self.mainTableView?.tableFooterView?.hidden = true
        }
    }
    
    //footerView
    func setFooterView() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 120))
        footerView.backgroundColor = UIColor.clearColor()
        
        let logOutBtn = UIButton(frame: CGRect(x: 20, y: 100, width: Width-44, height: 44))
        logOutBtn.backgroundColor = UIColor.whiteColor()
        logOutBtn.setTitle("无数据", forState: .Normal)
        logOutBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        logOutBtn.layer.cornerRadius = 5
        footerView.addSubview(logOutBtn)
        
        return footerView
    }
    
    //排序
    func sortDate(m1: AnyObject!, m2: AnyObject!) -> NSComparisonResult {
        if((m1 as! FindPetsCellModel).date.timeIntervalSince1970 > (m2 as! FindPetsCellModel).date.timeIntervalSince1970){
            return NSComparisonResult.OrderedAscending
        }else{
            return NSComparisonResult.OrderedDescending
        }
    }
    
////////////////////////tableView///////////////////////////
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cellData!.count
    }
    
    //cell显示的内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! FindPetsCellTableViewCell
        cell.delegate = self
        cell.isAll = true //
        //清空
        for subViews in cell.subviews{
            if subViews.isKindOfClass(UILabel) {
                let lable = subViews as! UILabel
                lable.removeFromSuperview()
            }
            if subViews.isKindOfClass(UIImageView) {
                let imageView = subViews as! UIImageView
                imageView.removeFromSuperview()
            }
            if subViews.isKindOfClass(UIButton) {
                let btn = subViews as! UIButton
                btn.removeFromSuperview()
            }
        }
        
        cell.showCellWithModel(self.cellData![indexPath.row] as! FindPetsCellFrameModel) //处理显示数据的大小高度问题
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        //设置删除
        cell.deleteView.tag = indexPath.row
        cell.deleteView.addTarget(self, action: #selector(deleteFindPets(_:)), forControlEvents: .TouchUpInside)
        
        //设置more
        cell.moreView.tag = indexPath.row
        cell.moreView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(moreFindPets(_:)))
        cell.moreView.addGestureRecognizer(tap)
        
        //设置hide
        if cell.hideView != nil {
            cell.hideView?.tag = indexPath.row
            cell.hideView?.addTarget(self, action: #selector(hideFindPets(_:)), forControlEvents: .TouchUpInside)
        }
        
        return cell
    }
    
    //more按钮
    func moreFindPets(sender: UITapGestureRecognizer){
        let more = sender.view
        ToastView().showToast("\(more?.tag)")
    }
    
    //hide按钮
    func hideFindPets(sender: UIButton){
        let hideIndex = sender.tag
        let indexPath = NSIndexPath.init(forRow: hideIndex, inSection: 0)
        self.mainTableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    
    //删除按钮
    func deleteFindPets(sender: UIButton){
        deledeIndex = sender.tag
        let deleteAlert = UIAlertView(title: "您确定要删除吗？", message: "", delegate: self,
                                      cancelButtonTitle: "取消", otherButtonTitles: "确定")
        deleteAlert.alertViewStyle = UIAlertViewStyle.Default
        deleteAlert.show()
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == 1{
            //先删除cellData
            cellData?.removeObjectAtIndex(deledeIndex)
            self.mainTableView?.reloadData()
            
            //删plist 删图片
            deletePlistData()
            
            if cellData?.count == 0 {
                self.refreshData()
            }
            
            ToastView().showToast("删除成功")
        }
    }
    
    //删plist
    func deletePlistData(){
        //提取原来的寻宠数据
        let findMyPetsData = SaveDataModel()
        let oldData = NSMutableArray()
        oldData.addObjectsFromArray(findMyPetsData.loadFindMyPetsDataFromTempDirectory())
        oldData.sortUsingComparator(sortDate)
        
        //获取图片数组
        let singleData = oldData.objectAtIndex(deledeIndex) as! FindPetsCellModel
        let imageName = singleData.picture
        if imageName != nil {
            let deleteImageData = SaveCacheDataModel()
            deleteImageData.deleteImageFromFindPetsCacheDir(imageName!)
        }
        
        oldData.removeObjectAtIndex(deledeIndex)
        
        let newData = oldData as NSArray
        //保存寻宠数据
        findMyPetsData.saveFindMyPetsToTempDirectory(newData as! [FindPetsCellModel])
        
    }
    
    //计算高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellFrame  = self.cellData![indexPath.row] as! FindPetsCellFrameModel
        return cellFrame.cellHeight
    }
    
    //此处添加footerView，方便找到contentSize的高度
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
       
        //如果不足一屏幕，不显示footer
        if(self.mainTableView!.contentSize.height <= self.mainTableView!.frame.height){
            self.mainTableView!.tableFooterView = UIView(frame: CGRectZero)
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

extension FindPetsViewController : FindPetsCellViewDelegate{
    
    func showPic(pic: [UIImage], index: Int, frame: [CGRect]) {
        picView.setUpPic(pic, index: index, frame: frame)
    }
}
