
//
//  FindPetsTableHeaderView.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

protocol FindPetsTableHeaderViewDelegate {
    func goMyInfoView()
    
    func changeBIM()
}

class FindPetsTableHeaderView: UIView {
    
    private var image: UIImageView!
    private var iconImage: UIImageView!
    private var label: UILabel!
    
    var delegate: FindPetsTableHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    func setupView(){
        //图
        image = UIImageView()
        image.frame = CGRect(x: 0, y: -20, width: self.frame.width, height: self.frame.height-50)
        self.refreshBIM()
        self.addSubview(image)
        
        image.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(changeBIM))
        image.addGestureRecognizer(tap1)
        
        let whiteView = UIView(frame: CGRect(x: 0, y: self.frame.height-70, width: self.frame.width, height: 70))
        whiteView.backgroundColor = UIColor.white
        self.addSubview(whiteView)
        
        //用户头像
        iconImage = UIImageView()
        iconImage.frame = CGRect(x: self.frame.width-100, y: self.frame.height-130, width: 80, height: 80)
        iconImage.layer.borderWidth = 4
        iconImage.layer.borderColor = UIColor.white.cgColor
        self.addSubview(iconImage)
        
        iconImage.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(goPersonInfo))
        iconImage.addGestureRecognizer(tap2)
        
        //用户名字
        label = UILabel()
        let font = UIFont.systemFont(ofSize: 20)
        label.font = font
        label.textColor = UIColor.white
        self.addSubview(label)
        
        self.refreshInfo()
    }
    
    func refreshInfo(){
        let imageView = myInfo.icon!
        iconImage.image = imageView
        
        let font = UIFont.systemFont(ofSize: 20)
        let labelSize = sizeWithText(myInfo.username!, font: font, maxSize: CGSize(width: Width, height: 100))
        label.frame = CGRect(x: iconImage.frame.minX - labelSize.width - 10, y: iconImage.frame.origin.y+20, width: labelSize.width, height: labelSize.height)
        label.text = myInfo.username!
        
    }
    
    func refreshBIM(){
        let saveCache = SaveCacheDataModel()
        let imageViewData = saveCache.loadImageFromFindPetsCacheDir("headerBIM.png")
        let imageView = ChangeValue.dataToImage(imageViewData)
        image.image = imageView
    }
    
    @objc private func goPersonInfo(){
        self.delegate?.goMyInfoView()
    }
    
    
    @objc private func changeBIM(){
        self.delegate?.changeBIM()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
