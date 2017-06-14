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
        let dataLable = UILabel(frame: CGRect(x: 0, y: 40, width: self.frame.width, height: 20))
        dataLable.textAlignment = .center
        dataLable.textColor = UIColor.red
        dataLable.font = UIFont.boldSystemFont(ofSize: 20)
        dataLable.text = title
        
        self.addSubview(dataLable)
        
        let clockView = MCYClockView(frame: CGRect(x: 0, y: dataLable.maxYY+10, width: self.frame.width, height: 300))
        self.addSubview(clockView)
    }
    
}
