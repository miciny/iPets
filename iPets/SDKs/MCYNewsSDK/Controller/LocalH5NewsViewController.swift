//
//  LocalNewsViewController.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/22.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//


//=========================相当于内嵌h5，有视频时很麻烦，试试本地处理的图文混排==========================================


import WebKit
import UIKit
import Alamofire
import SwiftyJSON

class LocalH5NewsViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler{
    fileprivate var netManager: SessionManager? //网络请求的manager
    fileprivate var dataModule: LocalNewsDataModule?
    fileprivate var webView: WKWebView!
    fileprivate let picView = ShowSinglePicView() //展示图片的
    fileprivate var loading: MyLoadingView?
    
    let newsID = "fxuapvw2034026-comos-ent-cms"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTitle()
        initNetManager()
        loadToutiaoCache()
    }
    
    // 停止视频
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        VideoFuncs.viewWillDisappearStopVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.webView = nil
    }
    
//=========================初始化数据==================================================
    //网络获取数据后，显示
    func setData(_ json: JSON){
        let json = json
        dataModule = JsonToModule.LocalNewJsonToModule(json)
        setupWebView()
    }
    
    //从本地获取缓存数据
    func loadToutiaoCache(){
        //是否显示loading，如果第一次从网上加载，就需要
        loading = MyLoadingView()
        loading!.setLoading(self.view, color: UIColor.black)
        loading!.show()
        
        if let json = JsonCache.loadjsonFromCacheDir(newsID){
            self.setData(json)
            loading?.hide()
        }else{
            self.getDataFromNet()
        }
    }

    //title,左边按钮和右边按钮
    func setUpTitle(){
        self.title = "极速新闻"
        self.view.backgroundColor = UIColor.white
    }
    
    //初始化webview
    func setupWebView(){
        let config = WKWebViewConfiguration()
        
        // Webview的偏好设置
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = false

        // 通过js与webview内容交互配置
        config.userContentController = WKUserContentController()
        // 添加一个名称，就可以在JS通过这个名称发送消息：
        //名字不同，调用不同的方法
        config.userContentController.add(self, name: "showSinglePic")
        config.userContentController.add(self, name: "playVideo")
        config.userContentController.add(self, name: "goWeibo")
        
        //加载本地js文件
        let scriptURL = Bundle.main.path(forResource: "LocalNews", ofType: "js")
        let scriptContent = try! String(contentsOfFile: scriptURL!, encoding: String.Encoding.utf8)
        let script = WKUserScript(source: scriptContent, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: Width, height: Height), configuration: config)
        self.webView.scrollView.isScrollEnabled = true
        self.webView.uiDelegate = self
        self.webView.backgroundColor = UIColor.white
        self.view.addSubview(self.webView)
        
        loadWebViewContent(dataModule!)
    }
    
    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //显示单张图片，根据传回的message.body
        if message.name == "showSinglePic" {
            if let picJson = dataModule!.pics{
                let index = message.body as! Int
                let picTemp = picJson[index]["data"]
                let kpic = picTemp["kpic"].stringValue
                let picWT = CGFloat(picTemp["width"].intValue)
                let picHT = CGFloat(picTemp["height"].intValue)
                
                picView.setUpPic(kpic, width: picWT, height: picHT)
            }
            
            
        }else if message.name == "playVideo"{
            let index = message.body as! Int
            playVideo(index)
            
            
        }else if message.name == "goWeibo"{
            let index = message.body as! Int
            //微博
            if let weiboJson = dataModule!.weibo{
                let weiboTemp = weiboJson[index]["data"]
                let url = weiboTemp["wapUrl"].stringValue
                
                let vc = WebViewController()
                vc.url = url
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //播放视频
    func playVideo(_ index: Int){
        
        if NetFuncs.checkNet() != networkType.wifi {
            ToastView().showToast("请连接Wi-Fi")
            return
        }
        
        if let videoJson = dataModule!.videos{
            let videoTemp = videoJson[index]["data"][0]
            let url = videoTemp["videoInfo"]["url"].stringValue
            
            // 初始化播放器
            
            //如果播放同一个视频，就返回
            if videoPlayer.videoUrl == url && videoPlayer.isPlayed == true{
                return
            }
            
            if videoPlayer.isPlayed == true{
                videoPlayer.stop()
            }
            
            let videoH = Width/2
            let videoTitle = videoTemp["title"].stringValue
            
            videoPlayer.setUpPlayer(CGRect(x: 0, y: 64, width: Width, height: videoH),
                                   videoUrl: url,
                                   indexPath: nil,
                                   videoTitle: videoTitle,
                                   showCloseBtn: true
            )
            self.view.addSubview(videoPlayer.mainView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//=====================================================================================================
/**
 MARK: - 正文
 **/
//=====================================================================================================

extension LocalH5NewsViewController{
    /**
     加载webView内容
     - parameter model: 新闻模型
     */
    func loadWebViewContent(_ model: LocalNewsDataModule) {
        
        // 内容页html
        var html = ""
        html.append("<!doctype html>")
        html.append("<head>")
        html.append("<meta name=\"viewport\" content=\"user-scalable=no, width=device-width, initial-scale=1\"/>")
        
        let css = getCSS()
        html.append(css)
        html.append("</head>")
        
        // body开始
        html.append("<body class=\"container\">")
        html.append("<div class=\"title\">\(model.title!)</div>") //标题
        html.append("<div class=\"time\">2016-06-20</div>") //时间
        html.append("<hr class=\"line\" >") //水平线
        
        // 拼接内容主体时替换图片
        var contentString = model.content!
        
        //段落两个空格
        contentString = contentString.replacingOccurrences(of: "<br/>", with: "<br/><br/>")
        
        //图片数量
        if let picJson = model.pics{
            for i in 0 ..< picJson.count{
                let picTemp = picJson[i]["data"]
                let alt = picTemp["alt"].stringValue
                let kpic = picTemp["kpic"].stringValue
                let picWT = picTemp["width"].intValue
                let picHT = picTemp["height"].intValue
                let picW = CGFloat(picWT)>(Width-60) ? (Width-60) : CGFloat(picWT)
                let picH = picW * CGFloat(picHT) / CGFloat(picWT)
                
                //图片
                contentString = contentString.replacingOccurrences(of: "<!--{IMG_\(i+1)}-->", with:
                    "<div align=\"center\"><img src=\"\(kpic)\" height=\"\(picH)\" width=\"\(picW)\" onclick=\"showSinglePic(\(i))\" /></div>" +
                    "<div class=\"picIntro\">\(alt)</div>")
            }
        }
        
        //视频数量, 现显示一个图片
        if let videoJson = model.videos{
            for i in 0 ..< videoJson.count{
                let videoTemp = videoJson[i]["data"][0]
                let title = videoTemp["title"].stringValue
                let kpic = videoTemp["videoInfo"]["kpic"].stringValue
                let videoW = Width-30
                let videoH = videoW*3/4
                let runtime = videoTemp["videoInfo"]["runtime"].intValue
                let runtimeStr = DataFormat.runtimeToDate(runtime)
                //视频
                contentString = contentString.replacingOccurrences(of: "<!--{VIDEO_MODULE_\(i+1)}-->", with:
                    "<div class-\"video\"><img src=\"\(kpic)\" height=\"\(videoH)\" width=\"\(videoW)\" onclick=\"playVideo(\(i))\" /></div>" +
                    "<div class=\"runtime\">\(runtimeStr)</div>" +
                    "<div class=\"picIntro\">\(title)</div>")
                
            }
        }
        
        //微博
        if let weiboJson = model.weibo{
            for i in 0 ..< weiboJson.count{
                let weiboTemp = weiboJson[i]["data"]
                let text = weiboTemp["text"].stringValue
                let name = weiboTemp["user"]["name"].stringValue
                //视频
                contentString = contentString.replacingOccurrences(of: "<!--{SINGLE_\(i+1)}-->", with:
                    "<div class=\"weibo\" onclick=\"goWeibo(\(i))\"><div >\(name)</div><br/>" +
                    "<div >\(text)</div></div>")
            }
        }
        
        //删除这个
        contentString = contentString.replacingOccurrences(of: "<br/><br/><!--{LEAD}--><br/>", with: "")
        //图片离太开，删一个空格
        contentString = contentString.replacingOccurrences(of: "><br/><br/>", with: "><br/>")
        
        html.append("<div class=\"content\">\(contentString)</div>")
        html.append("</body>")
        html.append("</html>")
        
//        let template = try! Template(string: html)
//        let rendering = try! template.render()
//        print(html)
        self.webView.loadHTMLString(html, baseURL: nil)
    }
    
    func getCSS() -> String {
        // css样式
        let css = "<style type=\"text/css\">" +
            //title
            ".title {" +
            "text-align: left;" +
            "font-size: 25px;" +
            "color: #3c3c3c;" +
            "font-weight: bold;" +
            "margin-left: 5px;" +
            "}" +
            
            //水平线
            ".line {" +
            "width: 100%;" +
            "size: 25px;" +
            "color: #CDC5BF;" +
            "}" +
            
            //时间
            ".time {" +
            "text-align: right;" +
            "font-size: 14px;" +
            "color: gray;" +
            "margin-top: 20px;" +
            "margin-bottom: 20px;" +
            "margin-left: 10px;" +
            "}" +
            
            //整个背景
            ".container {" +
            "background: #F8F8FF;" +
            "}" +
            
            //weibo
            ".weibo {" +
            "background: #FFFFFF;" +
            "font-size: 16px;" +
            "}" +
            
            //正文
            ".content {" +
            "width: 96%;" +
            "margin: 0 auto;" +
            "font-size: 18px;" +
            "line-height: 1.5;" +
            "}" +
            
            //图片简介
            ".picIntro {" +
            "text-align: left;" +
            "font-size: 15px;" +
            "color: gray;" +
            "}" +
            
            //视频时间
            ".runtime {" +
            "text-align: center;" +
            "font-size: 15px;" +
            "margin-top: -120px;" +
            "margin-bottom: 100px;" +
            "color: white;" +
            "}" +
            
            //视频时间
            ".video {" +
            "align: center;" +
            "}" +
            
        "</style>"
        
        return css
    }

}


//=====================================================================================================
/**
 MARK: - 网络请求
 **/
//=====================================================================================================

extension LocalH5NewsViewController{
    
    //初始化网络请求的manager
    func initNetManager(){
        netManager = NetFuncs.getDefaultAlamofireManager()
    }
    
    
    //网络请求数据,url参数的顺序还有影响？
    func getDataFromNet(){
        NetFuncs.showNetIndicator() //显示系统栏的网络状态
        let url = ArticleNetConstant().getCommonArticleURL("http%3A//ent.sina.cn/film/chinese/2016-07-15/detail-ifxuapvw2034026.d.html?fromsinago%3D1", postt: "news_news_ent_feed_87", newsId: newsID)
        
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
                        if JsonCache.savaJsonToCacheDir(json, name: self.newsID){
                            
                        }
                        
                        self.setData(json["data"])
                        //显示数据
                        ToastView().showToast("刷新完成！")
                        
                    }else{
                        ToastView().showToast("请求错误！")
                        print(response.response ?? "")
                    }
                    
                case .failure:
                    ToastView().showToast("无法连接！")
                    print(response.response ?? "")
                }
        }
    }
}
