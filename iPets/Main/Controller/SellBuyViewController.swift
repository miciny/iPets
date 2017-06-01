//
//  ViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit


class SellBuyViewController: UIViewController, UIScrollViewDelegate, isRefreshingDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, actionMenuViewDelegate , SearchViewDelegate{
    
    let customPresentAnimationController = CustomPresentAnimationController()
    let customDismissAnimationController = CustomDismissAnimationController()
    
    fileprivate let cellReuseIdentifier = "collectionCell"
    fileprivate let headerReuseIdentifier = "collectionHeader"
    fileprivate let footerReuseIdentifier = "collectionFooter"
    fileprivate var collectionView: UICollectionView?
    fileprivate var headerView: RefreshHeaderView? //自己写的
    
    fileprivate var addActionView: ActionMenuView?  //此处定义，方便显示和消失的判断
    fileprivate let addArray: NSDictionary = ["我的购物车": "ShoppingCart",
                                               "我的收藏": "MyFavorite",
                                               "我要开店": "OpenShop"]
    let pics = ["dog1.jpg",
                "dog2.jpeg",
                "dog3.jpg",
                "dog4.jpg",
                "dog5.jpg"]
    
    fileprivate var cellData: NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setUpCollection()
    }
    
    //退出界面，菜单消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if addActionView != nil {
            addActionView?.hideView()
            addActionView?.removeFromSuperview()
        }
    }
    
    func setUpEles(){
        self.view.backgroundColor = UIColor.white //背景色
        self.automaticallyAdjustsScrollViewInsets = false //解决scrollView自动偏移64的问题
        
        //右上角添加按钮
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(SellBuyViewController.addButtonClicked))
        self.navigationItem.rightBarButtonItem = addItem
        
        //左上角位置按钮
        let leftBarBtn = UIBarButtonItem(title: "北京", style: .plain, target: self,
                                         action: #selector(SellBuyViewController.addressButtonClicked))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //伪搜索框
        let titleView = UIView(frame: CGRect(x: 0, y: 8, width: Width-130, height: 32))
        titleView.backgroundColor = UIColor.white
        titleView.layer.cornerRadius = 16
        
        let labelIcon = UIImageView(frame: CGRect(x: 10, y: 9, width: 15, height: 15))
        labelIcon.image = UIImage(named: "SmallSearch")
        titleView.addSubview(labelIcon)
        
        let labelView = UILabel(frame: CGRect(x: 30, y: 0, width: titleView.frame.width-30, height: 32))
        labelView.text = "输入商品、店铺"
        labelView.font = UIFont.systemFont(ofSize: 13)
        labelView.textColor = UIColor.lightGray
        labelView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(SellBuyViewController.searchButtonClicked))
        labelView.addGestureRecognizer(tap)
        
        titleView.addSubview(labelView)
        
        self.navigationItem.titleView = titleView
    }
    
    //反向传值的函数，从搜索页返回后调用
    func search(_ label: String){
        
        let resultPage = SearchResultViewController()
        resultPage.pageTitle = label
        resultPage.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(resultPage, animated: true)
    }
    
    func addressButtonClicked(){
        
    }
    
    //点击右上角的添加按钮
    func addButtonClicked(){
        if(addActionView?.superview == nil){
            addActionView = ActionMenuView(object: addArray, center: CGPoint(x: Width, y: navigateBarHeight+90), target: self, showInView: self.view)
            addActionView!.eventFlag = 1 //可以不设置，默认为0，方便一个页面多次调用
        }else{
            addActionView?.hideView()
            addActionView?.removeFromSuperview()
        }
    }
    
    //数据
    func setUpData(){
        
        let items = [
            ["name":"小型萌宠","pic":"123_01.png"],
            ["name":"大型家宠","pic":"123_02.png"],
            ["name":"精品小店","pic":"123_03.png"],
            ["name":"身边宠店","pic":"123_01.png"],
            ["name":"我的家宠","pic":"123_02.png"],
            ["name":"入住商家","pic":"123_03.png"],
            ["name":"宠物周边","pic":"123_01.png"],
            ["name":"精品推荐","pic":"123_02.png"],
            ]
        
        let itemsOne = [
            ["name":"小型萌宠","pic":"123_01.png"],
            ["name":"大型家宠","pic":"123_02.png"],
            ["name":"精品小店","pic":"123_03.png"],
            ["name":"身边宠店","pic":"123_01.png"],
            ["name":"我的家宠","pic":"123_02.png"],
            ]
        
        let titles = ["头图",
                      "主荐萌宠",
                      "宠物分类",
                      "宠物周边",
                      "爱心失宠"]
        
        cellData = NSMutableArray()
        cellData?.add([titles[0], items])
        cellData?.add([titles[1], itemsOne])
        
    }
    
    
//===============================================代理================================
    
//==================================================================================actionMenuView的代理方法
    func menuClicked(_ tag: Int, eventFlag: Int) {
        switch eventFlag{
        case 1:
            switch tag{
            //我要寻宠页
            case 0:
                ToastView().showToast(addArray.allKeys[0] as! String)
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

    
//==================================================================================isfreshing中的代理方法
    func reFreshing(){
        
        collectionView!.setContentOffset(CGPoint(x: 0, y: 64-RefreshHeaderHeight*2), animated: true)
        collectionView!.isScrollEnabled = false
        //这里做你想做的事
        let _ = delay(0.5){
            self.collectionView!.isScrollEnabled = true
            self.collectionView!.setContentOffset(CGPoint(x: 0, y: 64-RefreshHeaderHeight), animated: true)
            
            self.headerView?.endRefresh()
            ToastView().showToast("刷新完成！")
            
        }
    }
    
//==================================================================================UICollectionViewDataSource
    //初始化collectionView
    func setUpCollection(){
        
        let layout = UICollectionViewFlowLayout() //也可自定义的
        layout.minimumLineSpacing = 0 //上下
        layout.minimumInteritemSpacing = 0 //左右
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 64, width: Width, height: Height-64-49), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
        
        headerView =  RefreshHeaderView(frame: collectionView!.frame, subView: collectionView!, target: self)  //添加下拉刷新
        
        //注册一个cell
        collectionView!.register(SellBuyCollectionViewCell.self, forCellWithReuseIdentifier:cellReuseIdentifier)
        //注册一个headView
        collectionView!.register(SellBuyCollectionHeaderView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        //注册一个footView
        collectionView!.register(SellBuyCollectionFooterView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.clear
        
        self.view.addSubview(collectionView!)
        
        setUpData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return cellData!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return ((cellData![section] as! NSArray)[1] as! NSArray).count
    }
    
    //collection的内容
    var originY = CGFloat()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SellBuyCollectionViewCell
//        cell.backgroundColor = UIColor.grayColor()
        
        //先清空内部原有的元素
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }
        
        let dic = ((cellData![indexPath.section] as! NSArray)[1] as! NSArray)[indexPath.row] as! NSDictionary
        let model = SellBuyCollectionModel(dic: dic)
        
        //布局
        if indexPath.section == 1{
            let offsetX = (Width)/4
            let offsetY = (Width)/4+15
            if indexPath.row == 0{
                originY = cell.frame.origin.y
                cell.frame = CGRect(x: 0, y: originY, width: (Width)/2, height: (Width)/2+30)
            }else{
                cell.frame.origin = CGPoint(x: Width/2 + offsetX*(CGFloat((indexPath.row-1)%2)), y: originY+offsetY*(CGFloat(indexPath.row/3)))
            }
        }

        cell.dataPic?.image = UIImage(named: model.picture!)
        cell.dataPic?.frame = CGRect(x: 10, y: 10, width: cell.frame.width-20, height: cell.frame.height-35)
        
        cell.dataLable?.text = model.name
        let dataLableSize = sizeWithText(model.name!, font: sellBuyLabelFont, maxSize: CGSize(width: Width, height: 20))
        cell.dataLable!.frame = CGRect(x: cell.frame.width/2-dataLableSize.width/2, y: (cell.dataPic?.frame)!.maxY+5, width: dataLableSize.width, height: 20)
        
        cell.addSubview(cell.dataPic!)
        cell.addSubview(cell.dataLable!)
        
        return cell
    }
    
    
    //分组头部、尾部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        switch kind{
            //头图部分
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! SellBuyCollectionHeaderView
            
            //清空原来的东西，不然重复显示
            //为什么会出现重复的数据？因为定义在类里的，就会重复利用，定义在方法里的就不会出现这个情况
            for sub in header.subviews{
                sub.removeFromSuperview()
            }
            
            //如果是第一个，就加载头图，如果不是，就加载普通
            if(indexPath.section == 0){
                header.addHeaderScrollPicsView(pics as NSArray)
                header.delegate = self
            }else{
                header.addHeaderTitleView(((cellData![indexPath.section] as! NSArray)[0] as! String))
            }

            return header
            
            //脚图部分
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath) as! SellBuyCollectionFooterView
            
            //清空原来的东西，不然重复显示
            for sub in footer.subviews{
                sub.removeFromSuperview()
            }
            
            if(indexPath.section == cellData!.count-1){
                footer.addFooterTitleView("请注意，这都是好东西！！！")
            }
            return footer
            
        default:
            return SellBuyCollectionHeaderView()
        }
    }
    
    //cell点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dic = ((cellData![indexPath.section] as! NSArray)[1] as! NSArray)[indexPath.row] as! NSDictionary
        let model = SellBuyCollectionModel(dic: dic)
//        ToastView().showToast(model.name!)
        
        //进入网页
        let iePage = InternetExplorerViewController()
        iePage.hidesBottomBarWhenPushed = true
        iePage.url = "http://www.baidu.com"
        iePage.title = model.name!
        self.navigationController?.pushViewController(iePage, animated: true)
    }
    
    //返回分组头部视图的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size = CGSize(width: Width, height: 30)
        
        if(section == 0){
            size = CGSize(width: Width, height: Width*0.5)
        }
        return size
    }
    
    //返回分组脚部视图的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        var size = CGSize(width: 0, height: 0)
        if(section == cellData!.count-1){
            size = CGSize(width: Width, height: 50)
        }
        return size
    }
    
    //cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //设置每一个cell的宽高
        return CGSize(width: (Width)/4, height: (Width)/4+15)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//==================================================================================进入搜索页动画的协议
extension SellBuyViewController: UIViewControllerTransitioningDelegate{
    
    //进入搜索页
    func searchButtonClicked(){
        
        let searchPage = SearchViewController()
        searchPage.delegate = self
        
        let searchPageNavigationController = UINavigationController(rootViewController: searchPage) //带导航栏
        searchPageNavigationController.transitioningDelegate = self
        
        self.present(searchPageNavigationController, animated: true, completion: nil)
    }
    
    //自定义动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPresentAnimationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customDismissAnimationController
    }
}

//==================================================================================点击头图的协议
extension SellBuyViewController: SellBuyHeaderDelegate{
    func selectedPic(_ str: String) {
        
        //进入网页
        let iePage = InternetExplorerViewController()
        iePage.hidesBottomBarWhenPushed = true
        iePage.url = "http://www.baidu.com"
        iePage.title = str
        self.navigationController?.pushViewController(iePage, animated: true)
    }
}
