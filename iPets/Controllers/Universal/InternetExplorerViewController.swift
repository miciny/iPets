//
//  InternetExplorerViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/25.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class InternetExplorerViewController: UIViewController {
    private let webView = UIWebView()
    var url: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpEles()
        openUrl()

        // Do any additional setup after loading the view.
    }
    
    //设置title 等
    func setUpEles(){
        self.view.backgroundColor = UIColor.whiteColor()
        
        webView.frame = self.view.frame
        webView.backgroundColor = UIColor.brownColor()
        self.view.addSubview(webView)
    }
    
    //打开网页
    func openUrl(){
        webView.loadRequest(NSURLRequest(URL: NSURL(string: url!)!))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
