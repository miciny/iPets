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
    func addFooterTitleView(title: String){
        
//        self.backgroundColor = UIColor.redColor()
        
        let dataLable = UILabel(frame: CGRectMake(0, 20, self.frame.width, 20))
        dataLable.textAlignment = .Center
        dataLable.font = UIFont.systemFontOfSize(15)
        dataLable.text = title
        
        self.addSubview(dataLable)
    }
    
}
