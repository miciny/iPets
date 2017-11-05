//
//  ShowPicViewController.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/21.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ShowPicViewController: UIViewController, UIScrollViewDelegate{
    var dataModule: NewsDataModule! //数据
    var indexPath : IndexPath! //postt参数做准备
    
    var netManager: SessionManager? //网络请求的manager
    var picScrollView: UIScrollView! //显示图片的scroll
    var showData : NSMutableArray? //数据
    var showPics : [UIImageView]? //图片
    var scrolls : [UIScrollView]? //图片的scroll 主要用于放大
    
    var picsCount : Int? //图片数量
    
    var introView : UIView? //显示简介的view
    var picCountLb : UILabel? //显示图片数量的view
    var titleLb : UILabel? //显示title
    var introText : UITextView? //显示图片简介的textview
    var titleStr : String? //显示图片简介的textview
    
    var backView : UIView? //顶部返回的view
    let introViewH = CGFloat(200)
    var loading: MyLoadingView?
    let newsID = "2841-101305-hdpic"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.picsCount = 8 //dataModule.total
        self.setUpTitle()
        self.setUpScrollView()
        self.initNetManager()
        self.setBackView()
        self.loadArticleCache()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //title,左边按钮和右边按钮
    func setUpTitle(){
        self.view.backgroundColor = UIColor.black
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//=========================初始化数据==================================================
    //网络获取数据后，显示
    func setData(_ json: JSON){
        showData = NSMutableArray()
        let json = json
        let picJson = json["picsModule"][0]["data"]
        self.titleStr = json["title"].stringValue
        
        //如果显示的图片数量与实际不符
        if self.picsCount != picJson.count{ //dataModule.total
            self.picsCount = picJson.count
            self.picScrollView.contentSize = CGSize(width: CGFloat(self.picsCount!)*Width, height: 0)
        }
        
        for i in 0 ..< picJson.count {
            let pic = picJson[i]
            showData?.add(JsonToModule.PicsJsonToModule(pic))
        }
        self.setUpImageView()
        
        //初始加载两张图片
        self.addImage(0)
        
        self.setIntroView()
    }
    
    //从本地获取缓存数据
    func loadArticleCache(){
        
        //是否显示loading，如果第一次从网上加载，就需要
        loading = MyLoadingView()
        loading!.setLoading(self.view, color: UIColor.white)
        loading!.show()
        
        if let json = JsonCache.loadjsonFromCacheDir(newsID){ //self.dataModule.newsId
            self.setData(json)
            loading?.hide()
        }else{
            self.getDataFromNet()
        }
    }
    
    //设置查看的scroll
    func setUpScrollView(){
        picScrollView = UIScrollView()
        picScrollView.frame = UIScreen.main.bounds
        picScrollView.backgroundColor = UIColor.black
        picScrollView.showsVerticalScrollIndicator = false
        picScrollView.showsHorizontalScrollIndicator = false
        picScrollView.isPagingEnabled = true
        picScrollView.delegate = self
        picScrollView.contentSize = CGSize(width: CGFloat(self.picsCount!)*Width, height: 0)
        picScrollView.tag = 100
        self.view.addSubview(picScrollView)
    }
    
    // 设置imageview
    func setUpImageView(){
        self.showPics = [UIImageView]()
        for i in 0 ..< self.picsCount! {
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Width, height: Height))
            imageView.backgroundColor = UIColor.clear
            self.showPics?.append(imageView)
            
            //进行缩放的
            let scroll = UIScrollView()
            scroll.frame = CGRect(x: CGFloat(i)*Width, y: -32, width: Width, height: Height)
            scroll.tag = i
            scroll.delegate = self
            scroll.maximumZoomScale = 2
            scroll.minimumZoomScale = 1
            scroll.showsVerticalScrollIndicator = false
            scroll.showsHorizontalScrollIndicator = false
            scroll.addSubview(imageView)
            
            scrolls?.append(scroll)
            self.picScrollView.addSubview(scroll)
        }
    }
    
    //缩放的view
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.tag != 100 {
            return self.showPics?[scrollView.tag]
        }
        return nil
    }
    
    //中心点缩放
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let view = scrollView.subviews.first
        if ((view?.height)! <= Height) {
            view!.center.y = Height/2
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 100 {
            let offsetX = scrollView.contentOffset.x
            let curentPage = Int(offsetX / Width)
            //一进去就代理了
            if showPics != nil {
                if curentPage >= 0 {
                    self.setUpPicIntro(curentPage)
                }
            }
            
            //恢复缩放
            for sView in scrollView.subviews{
                // 在根据⼦子类的对象类型进⾏行判断
                if sView.isKind(of: UIScrollView.classForCoder()) && sView.tag != curentPage{
                    // 把视图的尺⼨寸恢复到原有尺⼨寸
                    let view = sView as! UIScrollView
                    view.zoomScale = 1.0
                }
            }
        }
    }
    
    //滑动代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 100 {
            let offsetX = scrollView.contentOffset.x
            let curentPage = Int(offsetX / Width)
            //一进去就代理了
            if showPics != nil {
                if curentPage > 0 {
                    self.addImage(curentPage)
                }
                picCountLb?.text = "\(curentPage+1)/\(self.picsCount!)"
            }
        }
    }
    
    //加载图片
    func addImage(_ curentPage: Int){
    
        guard self.showPics != nil && curentPage < self.picsCount! else{
            return
        }
        
        //设置URL 加载图片
        let data = showData![curentPage] as! PicsDataModule
        var picUrl = String()
        if let gif = data.gif{
            picUrl = gif
        }else{
            picUrl = data.kpic!
        }
        
        if curentPage == 0{
            //初始化大小,等比缩放
            let width = CGFloat(data.width!)
            let height = CGFloat(data.height!)
            let picW = Width
            let picH = height * Width / width
            showPics![0].frame.size = CGSize(width: picW, height: picH)
            showPics![0].frame.origin.y = Height/2-picH/2       //32是高度调节
            
            NetFuncs.loadPic(imageView: showPics![0], picUrl: picUrl, complete: { (image) in
                self.addEvent(self.showPics![0])
            })
        }else{
            //如果有图片了就不加载了
            if showPics![curentPage].image == nil {
                showPics![curentPage].contentMode = .scaleAspectFit
                NetFuncs.loadPic(imageView: showPics![curentPage], picUrl: picUrl, complete: {(image) -> () in
                    //等比缩放
                    if let image = image{
                        let imageSize = image.size
                        let picW = Width
                        let picH = imageSize.height * Width / imageSize.width
                        self.showPics![curentPage].frame.size = CGSize(width: picW, height: picH)
                        self.showPics![curentPage].frame.origin.y = Height/2-picH/2      //32是高度调节
                        self.addEvent(self.showPics![curentPage])
                    }
                })
                logger.info("加载第\(curentPage+1)张图")
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
 MARK: - 简介的view
 **/
//=====================================================================================================

extension ShowPicViewController{
    //简介view
    func setIntroView(){
        introView = UIView(frame: CGRect(x: 0, y: Height-200, width: Width, height: introViewH))
        introView?.backgroundColor = UIColor.clear
        self.view.addSubview(introView!)
        
        //蒙层
        let introBlackView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: introViewH))
        introBlackView.backgroundColor = UIColor.black
        introBlackView.alpha = 0.6
        self.introView!.addSubview(introBlackView)
        
        //数量的
        picCountLb = UILabel(frame: CGRect(x: Width-10-80, y: 10, width: 80, height: 30))
        picCountLb?.textColor = UIColor.white
        picCountLb?.textAlignment = .right
        picCountLb?.text = "1/\(self.picsCount!)"
        self.introView!.addSubview(picCountLb!)
        
        //标题
        titleLb = UILabel(frame: CGRect(x: 10, y: 10, width: Width-100, height: 30))
        titleLb?.font = picTitleFont
        titleLb?.textColor = UIColor.white
        self.introView!.addSubview(titleLb!)
        
        //简介
        introText = UITextView(frame: CGRect(x: 10, y: 40, width: Width-20, height: introViewH-84))
        introText?.backgroundColor = UIColor.clear
        introText?.isEditable = false
        introText?.isSelectable = false
        introText?.font = picintroFont
        introText?.textColor = UIColor.lightGray
        self.introView!.addSubview(introText!)
        
        self.setUpPicTitle()
        self.setUpPicIntro(0)
    }
    
    //顶部返回
    func setBackView(){
        self.backView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 64))
        self.backView!.backgroundColor = UIColor.clear
        self.view.addSubview(self.backView!)
        
        //蒙层
        let backBlackView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 64))
        backBlackView.backgroundColor = UIColor.black
        backBlackView.alpha = 0.6
        self.backView!.addSubview(backBlackView)
        
        //返回按钮
        let backBtn = UIButton(frame: CGRect(x: 0, y: 23, width: 40, height: 40))
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.backView!.addSubview(backBtn)
        
        let backBtn1 = UIButton(frame: CGRect(x: 10, y: 30, width: 26, height: 26))
        backBtn1.setImage(UIImage(named: "navigation_back"), for: .normal)
        backBtn1.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.backView!.addSubview(backBtn1)
    }
    
    //添加事件
    func addEvent(_ imageView: UIImageView){
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissIntroView))
        imageView.addGestureRecognizer(tap)
    }
    
    // 点击图片，view消失,后续加动画
    @objc func dismissIntroView(){
        self.introView?.isHidden = !(self.introView?.isHidden)!
        self.backView?.isHidden = !(self.backView?.isHidden)!
    }
    
    //返回
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // 图集title
    func setUpPicTitle(){
        self.titleLb?.text = titleStr
    }
    
    //图集简介
    func setUpPicIntro(_ currentPage: Int){
        guard currentPage < self.picsCount! else{
            return
        }
        let data = showData![currentPage] as! PicsDataModule
        self.introText?.text = data.alt
    }
}


//=====================================================================================================
/**
 MARK: - 网络请求
 **/
//=====================================================================================================

extension ShowPicViewController{
    
    //初始化网络请求的manager
    func initNetManager(){
        netManager = NetFuncs.getDefaultAlamofireManager()
    }
    
    
    //网络请求数据,url参数的顺序还有影响？
    func getDataFromNet(){
        NetFuncs.showNetIndicator() //显示系统栏的网络状态
        let url = ArticleNetConstant().getPicChannelArticleURL("http%3A//photo.sina.cn/album_1_2841_101305.htm?ch%3D1%26fromsinago%3D1", postt: "hdpic_news_pic_feed_15", newsId: newsID)
        
        netManager!.request(url)
            .responseJSON { response in
                NetFuncs.hidenNetIndicator()    //隐藏系统栏的网络状态
                self.loading?.hide()
                
                switch response.result{
                case .success:
                    let code = String((response.response?.statusCode)!)
                    if code == "200"{
                        let json = JSON(response.result.value!)
                        //缓存到本地
                        if JsonCache.savaJsonToCacheDir(json, name: self.newsID){
                            
                        }//self.dataModule.newsId
                        
                        self.setData(json["data"])
                        
                    }else{
                        ToastView().showToast("请求错误！")
                        logger.info(response.response ?? "")
                    }
                    
                case .failure:
                    ToastView().showToast("无法连接！")
                    logger.info(response.response ?? "")
                }
        }
    }
}
