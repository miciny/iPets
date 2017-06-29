//
//  ShopCarViewController.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/12.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class ShopCarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpEle()
    }
    
    func setUpEle(){
        self.title = "购物车"
        self.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
