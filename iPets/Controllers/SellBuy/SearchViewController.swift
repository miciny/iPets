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
        self.view.backgroundColor = UIColor.whiteColor()
        
        //取消按钮
        let rightBarBtn = UIBarButtonItem(title: "取消", style: .Plain, target: self,
                                         action: #selector(SearchViewController.backToPrevious))
        
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    //搜索框
    func setUpSearchBar(){
        searchBar = UISearchBar(frame: CGRectMake(0, 20, self.view.frame.size.width-60, 44))
        searchBar.placeholder = "search"
        searchBar.barStyle = UIBarStyle.Default
        searchBar.searchBarStyle = UISearchBarStyle.Default
        searchBar.barTintColor = UIColor.clearColor()
        searchBar.backgroundColor = UIColor.clearColor()
        searchBar.tintColor = UIColor.blackColor()
        searchBar.translucent = true
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
        searchTable.tableFooterView = UIView(frame: CGRectZero)
        
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
                let str = (recordListDataTemp[i].valueForKey(SearchRecordNameOfLabel) as! String)
                let date = (recordListDataTemp[i].valueForKey(SearchRecordNameOfTime) as! NSDate)
                recordListData.addObject([str, date])
            }
            
            recordListData.sortUsingComparator(sortDate)
            
            // 提取数据
            
            let recordTitle = SearchRecordModel(record: recordListDicName, type: 0)
            searchData.addObject(recordTitle)
            
            for i in 0 ..< recordListData.count {
                let single = SearchRecordModel(record: (recordListData[i] as! NSArray)[0] as? String, type: 1)
                searchData.addObject(single)
            }
            
            let deleteTitle = SearchRecordModel(record: "清除记录", type: 2)
            searchData.addObject(deleteTitle)
        }
    }
    
    //排序
    func sortDate(m1: AnyObject!, m2: AnyObject!) -> NSComparisonResult {
        if(((m1 as! NSArray)[1] as! NSDate).timeIntervalSince1970 > ((m2 as! NSArray)[1] as! NSDate).timeIntervalSince1970){
            return NSComparisonResult.OrderedAscending
        }else{
            return NSComparisonResult.OrderedDescending
        }
    }
    
    // 输入框内容改变触发事件
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("过滤：\(searchText)")
    }
    
    // 书签按钮触发事件
    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        print("搜索历史")
    }
    
    // 取消按钮触发事件
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("取消搜索")
    }
    
    // 搜索触发事件
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let info = isExist(searchBar.text!)
        
        if !(info[0] as! Bool){
            SQLLine.InsertSearchrecordData(searchBar.text!, time: NSDate())
        }else{
            SQLLine.UpdateSearchrecordData(info[1] as! Int, changeValue: NSDate(), changeEntityName: SearchRecordNameOfTime)
        }
        
        self.backToPrevious()
        
        self.delegate?.search(searchBar.text!)
    }
    
    //返回
    func backToPrevious() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - uitabelview
    */
    //section个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    //每个section的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        count = searchData.count
        return count
        
    }
    
    //计算每个cell高度,固定44
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let height  = CGFloat(44)
        return height
    }
    
    
    //每个cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "SearchRecordCell"
        
        let data = searchData[indexPath.row] as? SearchRecordModel
        
        let cell =  SearchTableViewCell(data: data! , reuseIdentifier:cellId)
        
        if indexPath.row == 0 {
            cell.selectionStyle = .None
        }
        
        return cell
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //搜索历史
        if indexPath.row == 0 {
            return
        }else if indexPath.row == searchData.count-1{ //清除按钮
            let data = SQLLine.SelectAllData(entityNameOfSearchRecord)
            
            for _ in 0 ..< data.count {
                SQLLine.DeleteData(entityNameOfSearchRecord, indexPath: 0)
            }
            
            setUpData()
            self.searchTable.reloadData()
            
        }else{
            
            let data = searchData[indexPath.row] as? SearchRecordModel
            let labelText = data?.record
            
            let info = isExist(labelText!)
            
            if !(info[0] as! Bool){
                SQLLine.InsertSearchrecordData(labelText!, time: NSDate())
            }else{
                SQLLine.UpdateSearchrecordData(info[1] as! Int, changeValue: NSDate(), changeEntityName: SearchRecordNameOfTime)
            }
            
            self.backToPrevious()
            
            self.delegate?.search(labelText!)
        }
        
    }

    //headerView
    
    func setHeaderView(hotList: [String]) -> UIView{
        let headerView = UIView()
        let gap = CGFloat(20)
        
        let hotTitleSize = sizeWithText(hotListDicName, font: recordTitleFont, maxSize: CGSize(width: Width, height: 44))
        let hotTitle = UILabel(frame: CGRect(x: 10, y: 5, width: hotTitleSize.width, height: 30))
        hotTitle.backgroundColor = UIColor.clearColor()
        hotTitle.text = hotListDicName
        hotTitle.font = recordTitleFont
        hotTitle.textColor = UIColor.lightGrayColor()
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
            hot.backgroundColor = UIColor.clearColor()
            hot.textAlignment = .Center
            hot.layer.borderWidth = 0.8
            hot.layer.borderColor = UIColor.grayColor().CGColor
            hot.layer.cornerRadius = 5
            hot.text = hotList[i]
            hot.font = recordTitleFont
            hot.textColor = UIColor.lightGrayColor()
            
            //点击事件
            hot.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.tapedHot(_:)))
            hot.addGestureRecognizer(tap)
            
            headerView.addSubview(hot)
        }
        
        headerView.frame = CGRect(x: 0, y: 0, width: Width, height: lastY+44)
        headerView.backgroundColor = UIColor.whiteColor()
        
        return headerView
    }
    
    //点击了热门搜索
    func tapedHot(sender: UITapGestureRecognizer){
        
        let label = sender.view as! UILabel
        let info = isExist(label.text!)
        
        if !(info[0] as! Bool){
            SQLLine.InsertSearchrecordData(label.text!, time: NSDate())
        }else{
            SQLLine.UpdateSearchrecordData(info[1] as! Int, changeValue: NSDate(), changeEntityName: SearchRecordNameOfTime)
        }
        
        self.backToPrevious()
        
        self.delegate?.search(label.text!)
    }
    
    //数据库是否存在
    func isExist(label: String) -> NSArray{
        let recordListData = SQLLine.SelectAllData(entityNameOfSearchRecord)
        var flag = false
        var tag = 0
        
        for i in 0 ..< recordListData.count {
            if label == (recordListData[i].valueForKey(SearchRecordNameOfLabel) as! String){
                flag = true
                tag = i
            }
        }
        return [flag, tag]
    }
    
    //滑动，收起键盘
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
