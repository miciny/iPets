//
//  InternetExplorerViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/25.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//


//1，在Info.plist中添加 NSAppTransportSecurity 类型 Dictionary ;
//2，在 NSAppTransportSecurity 下添加 NSAllowsArbitraryLoads 类型Boolean ,值设为 YES;

import UIKit

class InternetExplorerViewController: UIViewController {
    fileprivate let webView = UIWebView()
    var url: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpEles()
        openUrl()

        // Do any additional setup after loading the view.
    }
    
    //设置title 等
    func setUpEles(){
        self.view.backgroundColor = UIColor.white
        
        webView.frame = self.view.frame
        webView.backgroundColor = UIColor.brown
        self.view.addSubview(webView)
    }
    
    //打开网页
    func openUrl(){
        webView.loadRequest(URLRequest(url: URL(string: url!)!))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
