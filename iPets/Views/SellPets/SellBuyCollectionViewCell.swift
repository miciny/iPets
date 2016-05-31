//
//  MyCollectionViewCell.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/17.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SellBuyCollectionViewCell: UICollectionViewCell {
    
    var dataLable: UILabel? //cell上title
    var dataPic: UIImageView? //cell上的图片
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dataPic = UIImageView()
        
        dataLable = UILabel()
        dataLable!.font = sellBuyLabelFont
        dataLable!.textAlignment = NSTextAlignment.Center
        dataLable!.backgroundColor = UIColor.clearColor()
        dataLable!.textColor = UIColor.blackColor()
        dataLable!.numberOfLines = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
