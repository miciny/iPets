//
//  WebViewController.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/22.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    fileprivate let webView = WKWebView()
    var url: String?
    fileprivate var progBar: UIProgressView? // 进度条
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProgBar()
        setUpEles()
        openUrl()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        removeObserver()
    }
    
    //设置title 等
    func setUpEles(){
        self.view.backgroundColor = UIColor.white
        
        self.webView.frame = CGRect(x: 0, y: 0, width: Width, height: self.view.height)
        self.webView.backgroundColor = UIColor.brown
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.progBar!)
        
        //进度通知
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    //打开网页
    func openUrl(){
        webView.load(URLRequest(url: URL(string: url!)!))
    }
    
    //设置进度条
    func setProgBar(){
        self.progBar = UIProgressView(progressViewStyle: .default)
        self.progBar?.frame = CGRect(x: 0, y: 65, width: Width, height: 4)
        self.progBar?.trackTintColor = UIColor.clear
        self.progBar?.progressTintColor = UIColor.green
        self.progBar?.progress = 0
        self.progBar?.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
    }
    
    //进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progBar?.alpha = 1.0
            progBar!.setProgress(Float(webView.estimatedProgress), animated: true)
            
            //进度条的值最大为1.0
            if(self.webView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3, delay: 0.2, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.progBar?.alpha = 0.0
                    }, completion: { (finished:Bool) -> Void in
                        self.progBar?.progress = 0
                })
            }
        }
    }
    
    func removeObserver(){
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
