//
//  SearchResultViewController.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/17.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {
    var pageTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        // Do any additional setup after loading the view.
    }
    
    func setUpEles(){
        self.title = pageTitle
        self.view.backgroundColor = UIColor.white
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
