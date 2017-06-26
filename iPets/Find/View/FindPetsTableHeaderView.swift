
//
//  FindPetsTableHeaderView.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class FindPetsTableHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    func setupView(){
        //图
        let image = UIImageView()
        image.frame = CGRect(x: 0, y: -20, width: self.frame.width, height: self.frame.height-50)
        let imageView = myInfo.icon!
        image.image = imageView
        self.addSubview(image)
        
        let whiteView = UIView(frame: CGRect(x: 0, y: self.frame.height-70, width: self.frame.width, height: 70))
        whiteView.backgroundColor = UIColor.white
        self.addSubview(whiteView)
        
        //用户头像
        let iconImage = UIImageView()
        iconImage.frame = CGRect(x: self.frame.width-100, y: self.frame.height-130, width: 80, height: 80)
        iconImage.layer.borderWidth = 4
        iconImage.layer.borderColor = UIColor.white.cgColor
        iconImage.image = imageView
        self.addSubview(iconImage)
        
        //用户名字
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 20)
        let labelSize = sizeWithText(myInfo.username!, font: font, maxSize: CGSize(width: Width, height: 100))
        label.frame = CGRect(x: iconImage.frame.minX - labelSize.width - 10, y: iconImage.frame.origin.y+20, width: labelSize.width, height: labelSize.height)
        label.font = font
        label.textColor = UIColor.white
        label.text = myInfo.username!
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
