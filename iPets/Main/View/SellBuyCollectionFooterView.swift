//
//  SellBuyCollectionFooterView.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/25.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

// 主页的底部图
class SellBuyCollectionFooterView: UICollectionReusableView {
    
    // 主页的最后的脚图
    func addFooterTitleView(_ title: String){
        
//        self.backgroundColor = UIColor.redColor()
        
        let dataLable = UILabel(frame: CGRect(x: 0, y: 20, width: self.frame.width, height: 20))
        dataLable.textAlignment = .center
        dataLable.font = UIFont.systemFont(ofSize: 15)
        dataLable.text = title
        
        self.addSubview(dataLable)
    }
    
}
