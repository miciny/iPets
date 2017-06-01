//
//  SearchViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/15.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    var searchBar : UISearchBar!
    var searchTable = UITableView()
    var searchData = NSMutableArray()
    
    var delegate : SearchViewDelegate? // 代理
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setUpSearchBar()
        setUpTable()
        setUpData()
        // Do any additional setup after loading the view.
    }
    

    func setUpEles(){
        self.view.backgroundColor = UIColor.white
        
        //取消按钮
        let rightBarBtn = UIBarButtonItem(title: "取消", style: .plain, target: self,
                                         action: #selector(SearchViewController.backToPrevious))
        
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    //搜索框
    func setUpSearchBar(){
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width-60, height: 44))
        searchBar.placeholder = "search"
        searchBar.barStyle = UIBarStyle.default
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.tintColor = UIColor.black
        searchBar.isTranslucent = true
        searchBar.showsBookmarkButton = false
        searchBar.showsCancelButton = false
        searchBar.showsSearchResultsButton = false
        searchBar.showsScopeBar = false
        searchBar.delegate = self
        
        //这个去掉背景的黑色
        searchBar.subviews[0].subviews[0].removeFromSuperview()
        
        //改颜色
//        for subView in searchBar.subviews{
//            for ndLeveSubView in subView.subviews{
//                if ndLeveSubView.isKindOfClass(UITextField){
//                    let subView = ndLeveSubView as! UITextField
//                    subView.textColor = UIColor.blackColor()
//                }else if ndLeveSubView.isKindOfClass(UIView){
//                    let subView = ndLeveSubView
//                    subView.backgroundColor = UIColor.clearColor()
//                }
//            }
//        }
        
        self.navigationController?.view.addSubview(searchBar)
        
        searchBar.becomeFirstResponder() //启功键盘
    }
    
    func setUpTable(){
        searchTable.frame = CGRect(x: 0, y: 0, width: Width, height: Height)  //为普通模式
        searchTable.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        searchTable.showsHorizontalScrollIndicator = false
        searchTable.tableFooterView = UIView(frame: CGRect.zero)
        
        searchTable.delegate = self
        searchTable.dataSource = self
        
        self.view.addSubview(searchTable)
    }
    
    func setUpData(){
        searchData = NSMutableArray()
        let recordListData = NSMutableArray()
        
        let hotData = ["二哈","金毛","仓鼠笼子","动物城","小米","大象鼻子","骆驼鸟","大象","老师","动物城","小米","大象"]
        let recordListDataTemp = SQLLine.SelectAllData(entityNameOfSearchRecord)
        
        if(hotData.count > 0){
            searchTable.tableHeaderView = setHeaderView(hotData)
        }
        
        if(recordListDataTemp.count>0){
            
            //先排序
            for i in 0 ..< recordListDataTemp.count {
                let str = ((recordListDataTemp[i] as AnyObject).value(forKey: SearchRecordNameOfLabel) as! String)
                let date = ((recordListDataTemp[i] as AnyObject).value(forKey: SearchRecordNameOfTime) as! Date)
                recordListData.add([str, date])
            }
            
            recordListData.sort(comparator: { (m1, m2) -> ComparisonResult in
                if(((m1 as! NSArray)[1] as! Date).timeIntervalSince1970 > ((m2 as! NSArray)[1] as! Date).timeIntervalSince1970){
                    return ComparisonResult.orderedAscending
                }else{
                    return ComparisonResult.orderedDescending
                }
            })
            
            // 提取数据
            
            let recordTitle = SearchRecordModel(record: recordListDicName, type: 0)
            searchData.add(recordTitle)
            
            for i in 0 ..< recordListData.count {
                let single = SearchRecordModel(record: (recordListData[i] as! NSArray)[0] as? String, type: 1)
                searchData.add(single)
            }
            
            let deleteTitle = SearchRecordModel(record: "清除记录", type: 2)
            searchData.add(deleteTitle)
        }
    }
    
    // 输入框内容改变触发事件
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("过滤：\(searchText)")
    }
    
    // 书签按钮触发事件
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("搜索历史")
    }
    
    // 取消按钮触发事件
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("取消搜索")
    }
    
    // 搜索触发事件
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let info = isExist(searchBar.text!)
        
        if !(info[0] as! Bool){
            if SQLLine.InsertSearchrecordData(searchBar.text!, time: Date()){
                print("插入搜索数据成功！")
            }else{
                print("插入搜索数据失败！")
            }
        }else{
            if SQLLine.UpdateSearchrecordData(info[1] as! Int, changeValue: Date() as AnyObject, changeEntityName: SearchRecordNameOfTime){
                print("更新搜索数据成功！")
            }else{
                print("更新搜索数据失败！")
            }
        }
        
        self.backToPrevious()
        self.delegate?.search(searchBar.text!)
    }
    
    //返回
    func backToPrevious() {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - uitabelview
    */
    //section个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        count = searchData.count
        return count
        
    }
    
    //计算每个cell高度,固定44
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height  = CGFloat(44)
        return height
    }
    
    
    //每个cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "SearchRecordCell"
        
        let data = searchData[indexPath.row] as? SearchRecordModel
        
        let cell =  SearchTableViewCell(data: data! , reuseIdentifier:cellId)
        
        if indexPath.row == 0 {
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //搜索历史
        if indexPath.row == 0 {
            return
        }else if indexPath.row == searchData.count-1{ //清除按钮
            let data = SQLLine.SelectAllData(entityNameOfSearchRecord)
            
            for _ in 0 ..< data.count {
                if SQLLine.DeleteData(entityNameOfSearchRecord, indexPath: 0){
                    print("删除数据成功！")
                }else{
                    print("删除数据失败！")
                }
            }
            
            setUpData()
            self.searchTable.reloadData()
            
        }else{
            
            let data = searchData[indexPath.row] as? SearchRecordModel
            let labelText = data?.record
            
            let info = isExist(labelText!)
            
            if !(info[0] as! Bool){
                if SQLLine.InsertSearchrecordData(labelText!, time: Date()){
                    print("新增搜索数据成功！")
                }else{
                    print("新增搜索数据失败！")
                }
                
            }else{
                if SQLLine.UpdateSearchrecordData(info[1] as! Int, changeValue: Date() as AnyObject, changeEntityName: SearchRecordNameOfTime){
                    print("更新搜索数据成功！")
                }else{
                    print("更新搜索数据失败！")
                }
            }
            
            self.backToPrevious()
            self.delegate?.search(labelText!)
        }
        
    }

    //headerView
    
    func setHeaderView(_ hotList: [String]) -> UIView{
        let headerView = UIView()
        let gap = CGFloat(20)
        
        let hotTitleSize = sizeWithText(hotListDicName, font: recordTitleFont, maxSize: CGSize(width: Width, height: 44))
        let hotTitle = UILabel(frame: CGRect(x: 10, y: 5, width: hotTitleSize.width, height: 30))
        hotTitle.backgroundColor = UIColor.clear
        hotTitle.text = hotListDicName
        hotTitle.font = recordTitleFont
        hotTitle.textColor = UIColor.lightGray
        headerView.addSubview(hotTitle)
        
        var lastX = gap
        var lastY = hotTitle.frame.maxY
        for i in 0 ..< hotList.count {
            let hotSize = sizeWithText(hotList[i], font: recordTitleFont, maxSize: CGSize(width: Width, height: 44))
            
            var x = lastX
            var y = lastY
            
            lastX = x + hotSize.width+gap*2
            if x + hotSize.width + gap >= Width {
                lastY = 44+lastY
                x = gap
                lastX = x + hotSize.width+gap*2
                y = lastY
            }
            
            let hot = UILabel(frame: CGRect(x: x, y: y, width: hotSize.width+gap, height: 30))
            hot.backgroundColor = UIColor.clear
            hot.textAlignment = .center
            hot.layer.borderWidth = 0.8
            hot.layer.borderColor = UIColor.gray.cgColor
            hot.layer.cornerRadius = 5
            hot.text = hotList[i]
            hot.font = recordTitleFont
            hot.textColor = UIColor.lightGray
            
            //点击事件
            hot.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.tapedHot(_:)))
            hot.addGestureRecognizer(tap)
            
            headerView.addSubview(hot)
        }
        
        headerView.frame = CGRect(x: 0, y: 0, width: Width, height: lastY+44)
        headerView.backgroundColor = UIColor.white
        
        return headerView
    }
    
    //点击了热门搜索
    func tapedHot(_ sender: UITapGestureRecognizer){
        
        let label = sender.view as! UILabel
        let info = isExist(label.text!)
        
        if !(info[0] as! Bool){
            if SQLLine.InsertSearchrecordData(label.text!, time: Date()){
                print("新增搜索数据成功！")
            }else{
                print("新增搜索数据失败！")
            }
            
        }else{
            if SQLLine.UpdateSearchrecordData(info[1] as! Int, changeValue: Date() as AnyObject, changeEntityName: SearchRecordNameOfTime){
                print("更新搜索数据成功！")
            }else{
                print("更新搜索数据失败！")
            }

        }
        
        self.backToPrevious()
        
        self.delegate?.search(label.text!)
    }
    
    //数据库是否存在
    func isExist(_ label: String) -> NSArray{
        let recordListData = SQLLine.SelectAllData(entityNameOfSearchRecord)
        var flag = false
        var tag = 0
        
        for i in 0 ..< recordListData.count {
            if label == ((recordListData[i] as AnyObject).value(forKey: SearchRecordNameOfLabel) as! String){
                flag = true
                tag = i
            }
        }
        return [flag, tag]
    }
    
    //滑动，收起键盘
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
