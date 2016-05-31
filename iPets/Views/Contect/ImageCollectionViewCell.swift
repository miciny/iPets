//
//  ImageCollectionCollectionViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/29.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var dataPic: UIImageView? //cell上的图片
    var checkPic: UIImageView? //cell上被选择的图片
    var isSelect = false
    
    var handleSelect:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dataPic = UIImageView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        self.addSubview(dataPic!)
        
        checkPic = UIImageView(frame: CGRectMake(self.frame.width-21, self.frame.height-21, 20, 20))
        checkPic?.layer.cornerRadius = 10
        self.addSubview(checkPic!)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
    }
    
    //如果太高清 如意造成内存崩溃？ 显示缩略图
    func update(image: ImageCollectionModel){
        self.dataPic!.image = UIImage(CGImage: image.asset.thumbnail().takeUnretainedValue())
//            .aspectRatioThumbnail().takeRetainedValue()) 
        isCheck(image.isSelect)
        isSelect = image.isSelect

    }
    
    func isCheck(isCheck: Bool) {
        if !isCheck{
            checkPic?.image = UIImage(named: "ImageNotCheck")
            checkPic?.backgroundColor = UIColor.clearColor()
        }else{
            checkPic?.image = UIImage(named: "ImageIsCheck")
            checkPic?.backgroundColor = UIColor.greenColor()
        }
    }
    
    func tap() {
        handleSelect?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
