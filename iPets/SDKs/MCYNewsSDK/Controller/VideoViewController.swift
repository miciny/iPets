//
//  VideoViewController.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/17.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VideoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var netManager: SessionManager? //网络请求的manager
    var mainTabelView: UITableView? //整个table
    var showData : NSMutableArray? //数据
    var refreshView: RefreshHeaderView? //自己写的刷新
    
    var footerView: LoadMoreView? //上拉加载更多
    var loading: MyLoadingView?
    var isloadmoreDone = false //只能上拉一次

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
        VideoFuncs.viewWillDisappearStopVideo() //停止视频
    }
    
    //title,左边按钮和右边按钮
    func setUpTitle(){
        self.view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        self.title = "视频"
        self.navigationItem.title = "视频"
    }
    
    
//=========================初始化数据==================================================
    //网络获取数据后，显示
    func setData(_ json: JSON){
        let json = json
        showData = NSMutableArray()
        let urlJson = json["feed"]
       
        for i in 0 ..< urlJson.count {
            let news = urlJson[i]
            if let module = JsonToModule.NewsJsonToModule(news, type: moduleType.video) {
                showData?.add(module)
            }
        }
        
        self.mainTabelView?.reloadData()
        
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
            if let module = JsonToModule.NewsJsonToModule(news, type: moduleType.video){
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
    
    //从本地获取缓存数据
    func loadToutiaoCache(){
        if let json = JsonCache.loadjsonFromCacheDir(String(describing: requestChannel.news_video)){
            
            self.setData(json)
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
        self.mainTabelView = UITableView(frame: CGRect(x: 0, y: 0, width: Width, height: Height), style: .grouped)  //为集合模式
        self.mainTabelView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        self.mainTabelView?.showsHorizontalScrollIndicator = false
        self.mainTabelView?.delegate = self
        self.mainTabelView?.dataSource = self
        
        self.refreshView =  RefreshHeaderView(subView: self.mainTabelView!, target: self)  //添加下拉刷新
        
        self.view.addSubview(self.mainTabelView!)
    }
    
    //section个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return showData!.count
    }
    
    //每个section的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //计算每个cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = showData![indexPath.section]
        let item =  data as! NewsDataModule
        let height  = item.cellHeight
        
        return height!
    }
    
    //每个cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "NewsListCell"
        let data = showData![indexPath.section] as! NewsDataModule
        let cell =  VideoTableViewCell(data: data, reuseIdentifier: cellId, indexPath: (indexPath as NSIndexPath) as IndexPath)
        
        return cell
    }
    
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabelView!.deselectRow(at: indexPath as IndexPath, animated: true)  //被选择后，会变灰，这么做还原
        
        let vc = LocalH5NewsViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //结束cell
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell滑出屏幕时，结束播放
        VideoFuncs.cellWillDisappearStopVideo((indexPath as NSIndexPath) as IndexPath)
    }
    
    //一个section头部的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == (showData?.count)!-1 {
            return 0.1
        }
        return 10
    }
    
    //此处添加footerView，方便找到contentSize的高度
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //如果不足一屏幕，不显示footer
        if(self.mainTabelView!.contentSize.height <= self.mainTabelView!.frame.height){
            self.mainTabelView!.tableFooterView = UIView(frame: CGRect.zero)
            return
        }
        
        if( footerView == nil && indexPath.section == self.showData!.count-1 && isloadmoreDone == false){
            footerView = LoadMoreView(frame: mainTabelView!.frame, subView: mainTabelView!, target: self)
        }
        
        if(indexPath.section == self.showData!.count-1){
            if isloadmoreDone == false {
                footerView?.refreshHeight()
                footerView?.showView()
            }
        }
    }

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

extension VideoViewController{
    
    //初始化网络请求的manager
    func initNetManager(){
        netManager = NetFuncs.getDefaultAlamofireManager()
    }
    
    
    //网络请求数据,url参数的顺序还有影响？
    func getDataFromNet(){
        NetFuncs.showNetIndicator() //显示系统栏的网络状态
        
        if loading == nil {
            loading = MyLoadingView()
            loading!.setLoading(self.view, color: UIColor.black)
        }
        if self.refreshView?.refreshState != RefreshState.refreshStateLoading {
            loading!.show()
        }
        
        doReuest(TabNetConstant().videoRequestURL, refresh: true)
    }
    
    
    //执行请求
    //refresh 是否下拉刷新的，否则上拉
    func doReuest(_ url: String, refresh: Bool){
        
        netManager!.request(url)
            .responseJSON { response in
                NetFuncs.hidenNetIndicator()    //隐藏系统栏的网络状态
                if refresh{
                    self.loading!.hide()
                }
                
                switch response.result{
                case .success:
                    let code = String((response.response?.statusCode)!)
                    if code == "200"{
                        let json = JSON(response.result.value!)
                        
                        //缓存到本地
                        if refresh{
                            if JsonCache.savaJsonToCacheDir(json, name: String(describing: requestChannel.news_video)){
                                
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

    //失败时调用
    func endFreshOrLoadMore(_ refresh: Bool){
        if refresh{
            self.endFresh()                 //停止刷新
        }else{
            self.endLoadMoreWithFail()
        }
    }
    
    //上啦加载更多
    func loadMoreDataFromNet(){
        let url = TabNetConstant().videoUpRequestURL
        
        NetFuncs.showNetIndicator() //显示系统栏的网络状态
        doReuest(url, refresh: false)
    }

}

//=====================================================================================================
/**
 MARK: - 刷新 加载更多
 **/
//=====================================================================================================

extension VideoViewController: isRefreshingDelegate, isLoadMoreDelegate{
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
    
    //点击tab时刷新
    func refreshVideoView() {
        self.refreshView?.startRefresh()
        
        hideFooterView()
    }
    
    //删除footer
    func hideFooterView(){
        if footerView != nil {
            footerView?.endRefresh()
            footerView?.hideView()
            footerView?.removeOberver()
            footerView = nil
        }
    }
}
