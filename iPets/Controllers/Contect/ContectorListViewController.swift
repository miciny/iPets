//
//  ContectorListViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ContectorListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{
    
    var contectorsDataDic: NSMutableDictionary?  //用于tableView显示的
    var mainTabelView: UITableView?
    var contectors : NSArray? //用于存储从数据库读取的数据
    var allKeys = NSArray() //用于存储所有的首字母
    var contectorsList: NSMutableArray? //用于存储数据库读取的数据转为 ContectorListModel，nameC 模式
    var searchBar = UISearchController() //搜索框
    var contectorsDataDicSearch: NSMutableDictionary? // 搜索匹配的结果，Table View使用这个数组作为datasource
    var allNameArray = [String]() //所有名字组

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setUpTable()
        loadDataFromDB()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //进入之前，把searchbar给cancel掉
        searchBar.active = false
    }
    
    //初始化界面
    func setUpEles(){
        self.title = "联系人"
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    //从数据库读取数据
    func loadDataFromDB(){
        contectorsDataDic = NSMutableDictionary()
        contectors = NSArray()
        allKeys = NSArray()
        contectorsList = NSMutableArray()
        contectorsDataDicSearch = NSMutableDictionary()
        
        contectors = SQLLine.SelectAllData(entityNameOfContectors)
        //如果没有数据，就直接返回
        if(contectors!.count == 0){
            return
        }
        
         //获取所有的联系人和首字母
        let allC = NSMutableArray()
        for i in 0 ..< contectors!.count {
            let name = contectors![i].valueForKey(ContectorsNameOfName) as! String

            let iconData = contectors![i].valueForKey(ContectorsNameOfIcon) as! NSData
            let icon = ChangeValue.dataToImage(iconData)
            
            let nameC = PinYinString.firstCharactor(name)  //获取首字母,这个函数比较慢，放这儿，到时候直接获取首字母，不用计算了
            let singleContect = ContectorListModel(name: name, icon: icon)
            
            contectorsList!.addObject([singleContect, nameC])
            allC.addObject(nameC)
        }
        let allSet = NSSet(array: allC as [AnyObject])
        allKeys = allSet.allObjects
        
        calculateData()
    }
    //排列
    func calculateData(){
        
        let headerCount = allKeys.count
        //整理联系人，按首字母来整理
        for j in 0  ..<  headerCount {
            let contectorsListSort = NSMutableArray()
            for i in 0 ..< contectorsList!.count {
                let contectorsListWithC = contectorsList![i] as! NSArray //获取［singleContect, nameC］
                let nameC = contectorsListWithC[1]  //获取首字母
                if(nameC as! String == allKeys[j] as! String){
                   contectorsListSort.addObject(contectorsListWithC[0])
                }
            }
            contectorsDataDic?.setValue(contectorsListSort, forKey: allKeys[j] as! String)
        }
        
        //处理keys,排序
        allKeys = contectorsDataDic?.allKeys as! [String] as NSArray
        allKeys = allKeys.sortedArrayUsingComparator(sortString)
        
        mainTabelView!.reloadData()
    }
    
    //按首字母排序方法
    func sortString(m1: AnyObject!, m2: AnyObject!) -> NSComparisonResult {
        if ((m1 as! String) < (m2 as! String)){
            return NSComparisonResult.OrderedAscending
        }else{
            return NSComparisonResult.OrderedDescending
        }
    }
    
//设置tableView*****************************
    //设置tableView
    func setUpTable(){
        mainTabelView = UITableView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))  //为普通模式
        mainTabelView!.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        mainTabelView!.showsHorizontalScrollIndicator = false
        mainTabelView!.tableFooterView = UIView(frame: CGRectZero) //消除底部多余的线
        
        mainTabelView!.delegate = self
        mainTabelView!.dataSource = self
        
        self.view.addSubview(mainTabelView!)
        
        //配置搜索控制器
        self.searchBar = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "搜索联系人"
            controller.searchBar.showsCancelButton = false  //显示取消按钮
            controller.searchBar.backgroundColor = UIColor.whiteColor()
            self.mainTabelView!.tableHeaderView = controller.searchBar
            
            //字体颜色
            let textFieldInsideSearchBar = controller.searchBar.valueForKey("searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = UIColor.blackColor()
            
            let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.valueForKey("placeholderLabel") as? UILabel
            textFieldInsideSearchBarLabel?.textColor = UIColor.grayColor()
        
            return controller
        })()
    }
    
    //section个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        如果搜索框激活了，就不要section了
        if searchBar.active {
            return 1
        }
        return allKeys.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchBar.active {
            return nil
        }
        return allKeys.objectAtIndex(section) as? String
    }
    
    //每个section的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //激活了，行数变化了
        if searchBar.active{
            let allValues = contectorsDataDicSearch?.valueForKey("$") as! NSArray
            return allValues.count
        }
        let contectorsList = contectorsDataDic?.valueForKey(allKeys[section] as! String)
        return contectorsList!.count
    }
    
    //计算每个cell高度,固定60
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let height  = CGFloat(60)
        return height
    }
    
    //每个cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "ContectorListCell"
        //如果激活了searchBar 就从 contectorsDataDicSearch提取数据
        if searchBar.active {
            let contectorsList = contectorsDataDicSearch?.valueForKey("$") as! NSArray
            let data = contectorsList[indexPath.row]
            let cell =  ContectorListTableViewCell(data: data as! ContectorListModel, reuseIdentifier:cellId)
            
            return cell
        }
        let contectorsList = contectorsDataDic?.valueForKey(allKeys[indexPath.section] as! String) as! NSArray
        let data = contectorsList[indexPath.row]
        let cell =  ContectorListTableViewCell(data: data as! ContectorListModel, reuseIdentifier:cellId)
        
        return cell
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mainTabelView!.deselectRowAtIndexPath(indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        //如果激活了searchBar 就从 contectorsDataDicSearch提取数据
        if searchBar.active {
            searchBar.active = false
            
            let contectorsList = contectorsDataDicSearch?.valueForKey("$") as! NSArray
            let data = contectorsList[indexPath.row] as! ContectorListModel
            let guestContectorVC = GuestContectorViewController()
            guestContectorVC.contectorName = data.name
            self.navigationController?.pushViewController(guestContectorVC, animated: true)
        }else{
            let contectorsList = contectorsDataDic?.valueForKey(allKeys[indexPath.section] as! String) as! NSArray
            
            let data = contectorsList[indexPath.row] as! ContectorListModel
            let guestContectorVC = GuestContectorViewController()
            guestContectorVC.contectorName = data.name
            self.navigationController?.pushViewController(guestContectorVC, animated: true)
        }
        
    }
    
    //重新计算数据
    func calculateSearchData(){
        let headerCount = allKeys.count
        let contectorsListSort = NSMutableArray()
        
        for j in 0  ..<  headerCount {
            for i in 0 ..< contectorsList!.count {
                let contectorsListWithC = contectorsList![i] as! NSArray //获取［singleContect, nameC］
                let nameC = contectorsListWithC[1]  //获取首字母
                if((nameC as! String == allKeys[j] as! String)){
                    contectorsListSort.addObject(contectorsListWithC[0])
                }
            }
        }
        contectorsDataDicSearch?.setValue(contectorsListSort, forKey: "$")
        self.mainTabelView?.reloadData()
    }
    
    //搜索结果展示
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.contectorsDataDicSearch?.removeAllObjects()
        self.allNameArray = []
        calculateSearchData()
        self.mainTabelView?.tableFooterView = UIView(frame: CGRectZero)
        
        //如果输入框没东西，就返回
        if searchBar.searchBar.text == "" {
            return
        }
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@",
                                          searchController.searchBar.text!)
        //获得所有名字组
        let contectorArray = contectorsDataDicSearch?.valueForKey("$") as! NSArray
        for i in 0 ..< contectorArray.count {
            let item = (contectorArray[i] as! ContectorListModel)
            allNameArray.append(item.name)
        }
        //获得搜索到的名字组
        let searchNameArray = (allNameArray as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        //在转为dictionary
        let tempArray = NSMutableArray()
        for i in 0 ..< searchNameArray.count {
            for j in 0 ..< contectorArray.count {
                let item = (contectorArray[j] as! ContectorListModel)
                if(item.name == searchNameArray[i] as! String){
                    tempArray.addObject(item)
                    break
                }
            }
        }
        self.contectorsDataDicSearch?.removeAllObjects()
        self.contectorsDataDicSearch?.setValue(tempArray, forKey: "$")
        self.mainTabelView?.reloadData()
        //搜索无结果
        if(tempArray.count == 0){
            self.mainTabelView?.tableFooterView = getFooterView()
        }else{
            self.mainTabelView?.tableFooterView = UIView(frame: CGRectZero)
        }
    }
    
    //无结果时显示
    func getFooterView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 44))
        view.backgroundColor = UIColor.clearColor()
        
        let noResultLb = UILabel(frame: view.frame)
        noResultLb.backgroundColor = UIColor.clearColor()
        noResultLb.textAlignment = .Center
        noResultLb.font = UIFont.systemFontOfSize(20)
        noResultLb.text = "没有相应结果"
        view.addSubview(noResultLb)
        
        return view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
