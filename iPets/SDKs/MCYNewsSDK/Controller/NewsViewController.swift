//
//  ViewController.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/16.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MCYRefresher

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, headerViewDelegate{
    
    var netManager: SessionManager? //网络请求的manager
    var mainTabelView: UITableView! //整个table
    var refreshView: MCYRefreshView? //自己写的刷新
    var footerView: MCYLoadMoreView? //上拉加载更多
    
    //进入页面要配置的
    var channel: String! //请求的url 的频道
    
    fileprivate var showData: NSMutableArray? //数据
    fileprivate var headerArray: [NewsHeaderDataModule]?
    fileprivate var headerView: NewsHeaderView? //头图
    fileprivate var loading: MyLoadingView?
    fileprivate var isloadmoreDone = false //只能上拉一次
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTitle()
        self.initNetManager()
        self.initShowData()
        self.setUpTable()
        self.loadToutiaoCache()
    }
    
    // 停止视频
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        VideoFuncs.viewWillDisappearStopVideo()
    }
    
    //title,左边按钮和右边按钮
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
    }
    
//=========================初始化数据==================================================
    //网络获取数据后，显示
    func setData(_ json: JSON){
        let json = json
        showData = NSMutableArray()
        let urlJson = json["feed"] //普通新闻的
        let headerJson = json["focus"] //头图的

        //如果没有focus，就不显示头图
        if headerJson != JSON.null && headerJson.count > 0 {
            setUpHeader(headerJson)
        }
        
        for i in 0 ..< urlJson.count {
            let news = urlJson[i]
            if let module = JsonToModule.NewsJsonToModule(news, type: moduleType.common){
                showData?.add(module)
            }
        }
        
        self.mainTabelView.reloadData()
        
        if footerView == nil {
            footerView = MCYLoadMoreView(subView: mainTabelView, target: self, imageName: "tableview_pull_refresh")
            self.mainTabelView.tableFooterView = footerView
        }else{
            self.mainTabelView.tableFooterView = UIView(frame: CGRect.zero)
        }
        
        isloadmoreDone = false
        self.endFresh()                 //停止刷新
    }
    
    
    //上拉加载更多的数据
    func setLoadMoreData(_ json: JSON){
        let json = json
        let urlJson = json["feed"] //普通新闻的
        
        //获取原id
        var newsids = [String]()
        let countID = showData!.count
        for i in 0 ..< countID{
            let module = showData![i] as! NewsDataModule
            let id = module.newsId
            newsids.append(id!)
        }
        
        for i in 0 ..< urlJson.count {
            let news = urlJson[i]
            if let module = JsonToModule.NewsJsonToModule(news, type: moduleType.common){
                let newsID = module.newsId
                //去重
                if !newsids.contains(newsID!) {
                    showData?.add(module)
                }
            }
        }
        
        self.mainTabelView?.reloadData()
        
        isloadmoreDone = true
        self.endLoadMore()                 //停止刷新
    }

    
    //设置头图
    func setUpHeader(_ json: JSON){
        defer{
            self.headerView?.setData()
        }
        
        self.headerArray = [NewsHeaderDataModule]()
        
        for i in 0 ..< json.count {
            let header = json[i]
            self.headerArray?.append(JsonToModule.HeaderJsonToModule(header))
        }
       
        //如果存在，就只传数据
        if self.headerView != nil {
            self.headerView?.headerData = self.headerArray
            self.headerView?.refreshData()
            return
        }
        
        self.headerView = NewsHeaderView(frame: CGRect(x: 0, y: 0, width: Width, height: Width/2), target: self)
        //给header设置数据
        self.headerView?.headerData = self.headerArray
        self.headerView?.setUpView()
        self.mainTabelView?.tableHeaderView = self.headerView
    }
    
    //从本地获取缓存数据
    func loadToutiaoCache(){
        //是否显示loading，如果第一次从网上加载，就需要
        loading = MyLoadingView()
        loading!.setLoading(self.view, color: UIColor.black)
        loading!.show()
        
        if let json = JsonCache.loadjsonFromCacheDir(String(self.channel)){
            self.setData(json)
            loading!.hide()
        }else{
            self.getDataFromNet()
        }
    }

    //无数据时，先展示空的
    func initShowData(){
        showData = NSMutableArray()
    }
    
//=========================初始化tableView以及代理方法==================================================
    //设置tableView
    func setUpTable(){
        self.mainTabelView = UITableView(frame: CGRect(x: 0, y: 0, width: Width, height: Height-103))  //为普通模式 tab高度49
        self.mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.mainTabelView?.showsHorizontalScrollIndicator = false
        self.mainTabelView?.tableFooterView = UIView(frame: CGRect.zero) //消除底部多余的线
        
        self.mainTabelView?.delegate = self
        self.mainTabelView?.dataSource = self
        self.mainTabelView?.scrollsToTop = false
        
        self.refreshView = MCYRefreshView(subView: self.mainTabelView!, target: self, imageName: "tableview_pull_refresh")  //添加下拉刷新
        
        self.view.addSubview(self.mainTabelView!)
    }
    
    
    //代理事件
    func newsClicked(_ data: NewsHeaderDataModule) {
        if let category = data.category{
            goNewsDetail(category, data: nil, headerData: data)
        }
    }
    
    //section个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showData!.count
    }
    
    //计算每个cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = showData![indexPath.row]
        let item =  data as! NewsDataModule
        let height  = item.cellHeight
        
        return height!
    }
    
    //每个cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "NewsListCell"
        let data = showData![indexPath.row] as! NewsDataModule
        let cell =  NewsTableViewCell(data: data, reuseIdentifier: cellId, indexPath: (indexPath as NSIndexPath) as IndexPath)
        
        return cell
    }
    
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabelView!.deselectRow(at: indexPath as IndexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        let data = showData![indexPath.row] as! NewsDataModule
        goNewsDetail(data.category, data: data, headerData: nil)
    }
    
    //结束cell
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell滑出屏幕时，结束播放
        VideoFuncs.cellWillDisappearStopVideo((indexPath as NSIndexPath) as IndexPath)
    }
    
    //根据类型进入新闻
    func goNewsDetail(_ category: newsType, data: NewsDataModule?, headerData: NewsHeaderDataModule?){
        
        //图片页
        if category == newsType.hdpic{
            let vc = ShowPicViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.dataModule = data //现在是假的
            self.navigationController?.pushViewController(vc, animated: true)
            //url
        }else if category == newsType.url || category == newsType.plan{
            let vc = WebViewController()
            
            //需要判断是头图还是列表
            if let data1 = data{
                vc.url = data1.link
                vc.title = data1.title //设置标题
            }else if let data2 = headerData{
                vc.url = data2.link
                vc.title = data2.title //设置标题
            }
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            //普通新闻 blog 原创 视频
        }else if category == newsType.cms || category == newsType.blog || category == newsType.original || category == newsType.video{
            let vc = LocalH5NewsViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if category == newsType.live || category == newsType.subject || category == newsType.consice{
            ToastView().showToast("未实现")
        }
    }

    //didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//=====================================================================================================
/**
 MARK: - 网络请求
 **/
//=====================================================================================================

extension NewsViewController{
    
    //初始化网络请求的manager
    func initNetManager(){
        netManager = NetFuncs.getDefaultAlamofireManager()
    }
    
    
    //网络请求数据,url参数的顺序还有影响？
    func getDataFromNet(){
        
        var url = String()
        let channelType = DataFormat.strToNewsChannel(self.channel)
        switch channelType {
        case requestChannel.news_toutiao:
            url = TabNetConstant().toutiaoRequestURL
        case requestChannel.news_funny:
            url = TabNetConstant().gaoxiaoRequestURL
        case requestChannel.news_ent:
            url = TabNetConstant().yuleRequestURL
        case requestChannel.news_sports:
            url = TabNetConstant().tiyuRequestURL
        case requestChannel.news_tech:
            url = TabNetConstant().kejiRequestURL
        case requestChannel.news_mil:
            url = TabNetConstant().junshiRequestURL
        default:
            url = TabNetConstant().toutiaoRequestURL
        }
        
        NetFuncs.showNetIndicator() //显示系统栏的网络状态
        doReuest(url, refresh: true)
    }
    
    //执行请求
    //refresh 是否下拉刷新的，否则上拉
    func doReuest(_ url: String, refresh: Bool){
        
        netManager!.request(url)
            .responseJSON { response in
                NetFuncs.hidenNetIndicator()    //隐藏系统栏的网络状态
                self.loading!.hide()
                
                switch response.result{
                case .success:
                    let code = String((response.response?.statusCode)!)
                    if code == "200"{
                        let json = JSON(response.result.value!)
                        
                        //缓存到本地
                        if refresh{
                            if JsonCache.savaJsonToCacheDir(json, name: String(self.channel)){
                                
                            }//下拉的缓存 上拉加载更多的就不缓存了
                        }
                        
                        let JsonData = json["data"]
                        //显示数据
                        if refresh{
                            self.setData(JsonData)
                        }else{
                            self.setLoadMoreData(JsonData)
                        }
                        
                        ToastView().showToast("刷新完成！")
                        
                    }else{
                        self.endFreshOrLoadMore(refresh)
                        
                        ToastView().showToast("请求错误！")
                        print(response.response ?? "")
                    }
                    
                case .failure:
                    self.endFreshOrLoadMore(refresh)
                    ToastView().showToast("无法连接！")
                    print(response.response ?? "")
                }
        }
    }
    
    //都是失败时调用
    func endFreshOrLoadMore(_ refresh: Bool){
        if refresh{
            self.endFresh()                 //停止刷新
        }else{
            self.endLoadMoreWithFail()
        }
    }
    
    
    //上啦加载更多
    func loadMoreDataFromNet(){
        var url = String()
        let channelType = DataFormat.strToNewsChannel(self.channel)
        switch channelType {
        case requestChannel.news_toutiao:
            url = TabNetConstant().toutiaoUpRequestURL
        case requestChannel.news_funny:
            url = TabNetConstant().gaoxiaoUpRequestURL
        case requestChannel.news_ent:
            url = TabNetConstant().yuleUpRequestURL
        case requestChannel.news_sports:
            url = TabNetConstant().tiyuUpRequestURL
        case requestChannel.news_tech:
            url = TabNetConstant().kejiUpRequestURL
        case requestChannel.news_mil:
            url = TabNetConstant().junshiUpRequestURL
        default:
            url = TabNetConstant().toutiaoUpRequestURL
        }
        
        NetFuncs.showNetIndicator() //显示系统栏的网络状态
        doReuest(url, refresh: false)
    }
}


//=====================================================================================================
/**
 MARK: - 刷新 加载更多
 **/
//=====================================================================================================

extension NewsViewController: MCYRefreshViewDelegate, MCYLoadMoreViewDelegate{
    //isfreshing中的代理方法
    func reFreshing(){
        //这里做你想做的事
        self.getDataFromNet()
        hideFooterView()
    }
    
    //结束刷新时调用
    func endFresh(){
        self.refreshView?.endRefresh()
        
    }
    
    //加载更多
    func loadingMore() {
        //这里做你想做的事
        loadMoreDataFromNet()
    }
    
    //成功加载更多
    func endLoadMore(){
        hideFooterView()
    }
    
    //加载更多失败
    func endLoadMoreWithFail(){
        if let footer = self.footerView{
            footer.endRefresh()
        }
    }
    
    //删除footer
    func hideFooterView(){
        if footerView != nil {
        
            footerView?.hideView()
            self.mainTabelView.tableFooterView = UIView(frame: CGRect.zero)
            footerView = nil
        }
    }
}
