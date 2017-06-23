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
    var allKeys = [String]() //用于存储所有的首字母
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //进入之前，把searchbar给cancel掉
        searchBar.isActive = false
    }
    
    //初始化界面
    func setUpEles(){
        self.title = "联系人"
        self.view.backgroundColor = UIColor.white
        
    }
    
    //从数据库读取数据
    func loadDataFromDB(){
        contectorsDataDic = NSMutableDictionary()
        contectors = NSArray()
        allKeys = [String]()
        contectorsList = NSMutableArray()
        contectorsDataDicSearch = NSMutableDictionary()
        contectors = SQLLine.SelectAllData(entityNameOfContectors)
        
        //如果没有数据，就直接返回
        if(contectors!.count == 0){
            self.mainTabelView!.isScrollEnabled = false
            self.mainTabelView!.tableHeaderView?.isHidden = true
            return
        }
        
         //获取所有的联系人和首字母
        let allC = NSMutableArray()
        for i in 0 ..< contectors!.count {
            let name = (contectors![i] as! Contectors).name!
            let iconData = (contectors![i] as! Contectors).icon! as Data
            let icon = ChangeValue.dataToImage(iconData)
            let nickame = (contectors![i] as! Contectors).nickname!
            
            let nameC = PinYinString.firstCharactor(name)  //获取首字母,这个函数比较慢，放这儿，到时候直接获取首字母，不用计算了
            let singleContect = ContectorListViewDataModel(name: name, icon: icon, nickname: nickame)
            
            contectorsList!.add([singleContect, nameC])
            allC.add(nameC)
        }
        let allSet = NSSet(array: allC as [AnyObject])
        allKeys = allSet.allObjects as! [String]
        
        calculateData()
    }
    
    //排列
    func calculateData(){
        
        let myQueue = DispatchQueue(label: "myQueue")  //
        myQueue.async {
            let headerCount = self.allKeys.count
            //整理联系人，按首字母来整理
            for j in 0  ..<  headerCount {
                let contectorsListSort = NSMutableArray()
                for i in 0 ..< self.contectorsList!.count {
                    let contectorsListWithC = self.contectorsList![i] as! NSArray //获取［singleContect, nameC］
                    let nameC = contectorsListWithC[1]  //获取首字母
                    if(nameC as! String == self.allKeys[j]){
                        contectorsListSort.add(contectorsListWithC[0])
                    }
                }
                self.contectorsDataDic?.setValue(contectorsListSort, forKey: self.allKeys[j])
            }
            
            //处理keys,排序
            self.allKeys = self.contectorsDataDic?.allKeys as! [String]
            self.allKeys = self.allKeys.sorted()
            
            mainQueue.async {
                self.mainTabelView!.reloadData()
            }
        }
    }
    
//==========================================设置tableView*****************************
    //设置tableView
    func setUpTable(){
        mainTabelView = UITableView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))  //为普通模式
        mainTabelView!.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        mainTabelView!.showsHorizontalScrollIndicator = false
        mainTabelView!.tableFooterView = UIView(frame: CGRect.zero) //消除底部多余的线
        mainTabelView!.delegate = self
        mainTabelView!.dataSource = self
        self.view.addSubview(mainTabelView!)
        
        //配置搜索控制器
        self.searchBar = ({
            let controller = UISearchController(searchResultsController: nil) //要为nil。才能在原页面显示结果
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .minimal
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "搜索联系人"
            controller.searchBar.showsCancelButton = false  //显示取消按钮
            controller.searchBar.backgroundColor = UIColor.white
            self.mainTabelView!.tableHeaderView = controller.searchBar
            
            //字体颜色
            let textFieldInsideSearchBar = controller.searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = UIColor.black
            
            let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
            textFieldInsideSearchBarLabel?.textColor = UIColor.gray
        
            return controller
        })()
    }
    
    //section个数
    func numberOfSections(in tableView: UITableView) -> Int {
//        如果搜索框激活了，就不要section了
        if searchBar.isActive {
            return 1
        }
        return allKeys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchBar.isActive {
            return nil
        }
        return allKeys[section]
    }
    
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //激活了，行数变化了
        if searchBar.isActive{
            let allValues = contectorsDataDicSearch?.value(forKey: "$") as! NSArray
            return allValues.count
        }
        let contectorsList = contectorsDataDic?.value(forKey: allKeys[section])
        return (contectorsList! as AnyObject).count
    }
    
    //计算每个cell高度,固定60
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height  = CGFloat(60)
        return height
    }
    
    //每个cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "ContectorListCell"
        //如果激活了searchBar 就从 contectorsDataDicSearch提取数据
        if searchBar.isActive {
            let contectorsList = contectorsDataDicSearch?.value(forKey: "$") as! NSArray
            let data = contectorsList[indexPath.row] as! ContectorListViewDataModel
            let cell = ContectorListTableViewCell(data: data, reuseIdentifier:cellId)
            
            return cell
        }
        
        let contectorsList = contectorsDataDic?.value(forKey: allKeys[indexPath.section]) as! NSArray
        let data = contectorsList[indexPath.row]
        let cell = ContectorListTableViewCell(data: data as! ContectorListViewDataModel, reuseIdentifier:cellId)
        
        return cell
    }
    
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabelView!.deselectRow(at: indexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        //如果激活了searchBar 就从 contectorsDataDicSearch提取数据
        if searchBar.isActive {
            
            let contectorsList = contectorsDataDicSearch?.value(forKey: "$") as! NSArray
            let data = contectorsList[indexPath.row] as! ContectorListViewDataModel
            let guestContectorVC = ContectorInfoViewController()
            guestContectorVC.contectorNickName = data.nickname
            
            searchBar.isActive = false
            self.navigationController?.pushViewController(guestContectorVC, animated: true)
        }else{
            let contectorsList = contectorsDataDic?.value(forKey: allKeys[indexPath.section]) as! NSArray
            let data = contectorsList[indexPath.row] as! ContectorListViewDataModel
            let guestContectorVC = ContectorInfoViewController()
            guestContectorVC.contectorNickName = data.nickname
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
                if((nameC as! String == allKeys[j])){
                    contectorsListSort.add(contectorsListWithC[0])
                }
            }
        }
        contectorsDataDicSearch?.setValue(contectorsListSort, forKey: "$")
        self.mainTabelView?.reloadData()
    }
    
    //搜索结果展示
    func updateSearchResults(for searchController: UISearchController) {
        self.contectorsDataDicSearch?.removeAllObjects()
        self.allNameArray = []
        calculateSearchData()
        self.mainTabelView?.tableFooterView = UIView(frame: CGRect.zero)
        
        //如果输入框没东西，就返回
        if searchBar.searchBar.text == "" {
            return
        }
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@",
                                          searchController.searchBar.text!)
        //获得所有名字组
        let contectorArray = contectorsDataDicSearch?.value(forKey: "$") as! NSArray
        for i in 0 ..< contectorArray.count {
            let item = (contectorArray[i] as! ContectorListViewDataModel)
            allNameArray.append(item.name)
        }
        //获得搜索到的名字组
        let searchNameArray = (allNameArray as NSArray).filtered(using: searchPredicate)
        
        //在转为dictionary
        let tempArray = NSMutableArray()
        for i in 0 ..< searchNameArray.count {
            for j in 0 ..< contectorArray.count {
                let item = (contectorArray[j] as! ContectorListViewDataModel)
                if(item.name == searchNameArray[i] as! String){
                    tempArray.add(item)
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
            self.mainTabelView?.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    //无结果时显示
    func getFooterView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 44))
        view.backgroundColor = UIColor.clear
        
        let noResultLb = UILabel(frame: view.frame)
        noResultLb.backgroundColor = UIColor.clear
        noResultLb.textAlignment = .center
        noResultLb.font = UIFont.systemFont(ofSize: 20)
        noResultLb.text = "没有相应结果"
        view.addSubview(noResultLb)
        
        return view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
