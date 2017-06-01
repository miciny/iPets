//
//  ImageCollectionCollectionViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/29.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Photos

class ImageCollectionViewCell: UICollectionViewCell {
    
    var dataPic: UIImageView? //cell上的图片
    var checkPic: UIImageView? //cell上被选择的图片
    var isSelect = false
    
    var handleSelect:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dataPic = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        dataPic!.contentMode = .scaleToFill
        self.addSubview(dataPic!)
        
        checkPic = UIImageView(frame: CGRect(x: self.frame.width-21, y: self.frame.height-21, width: 20, height: 20))
        checkPic?.layer.cornerRadius = 10
        self.addSubview(checkPic!)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
    }
    
    //如果太高清 如意造成内存崩溃？ 显示缩略图
    func update(_ image: ImageCollectionModel){
        getThumbnailImage(asset: image.asset, imageResult: { (image) in
            self.dataPic!.image = image
        })
        
        isCheck(image.isSelect)
        isSelect = image.isSelect
    }
    
    func isCheck(_ isCheck: Bool) {
        if !isCheck{
            checkPic?.image = UIImage(named: "ImageNotCheck")
            checkPic?.backgroundColor = UIColor.clear
        }else{
            checkPic?.image = UIImage(named: "ImageIsCheck")
            checkPic?.backgroundColor = UIColor.green
        }
    }
    
    func tap() {
        handleSelect?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
