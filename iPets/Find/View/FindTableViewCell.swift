//
//  FindTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/9.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class FindTableViewCell: UITableViewCell {

    var findItem: FindDataModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: FindDataModel, reuseIdentifier cellId: String){
        self.findItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        
        rebuildCell()
    }
    
    func rebuildCell(){
        
        //普通设置栏-title
        let title = getLabel(title: findItem.title, font: findPageLabelFont)
        title.frame.origin.x = 60
        title.center.y = 22
        self.addSubview(title)
        
        if let icon = findItem.icon{
            //普通设置栏-头像 高度44
            let myIcon = UIImageView(frame: CGRect(x: 20, y: 7, width: 30, height: 30))
            myIcon.backgroundColor = UIColor.clear
            myIcon.image = UIImage(named: icon)
            myIcon.layer.cornerRadius = 0
            self.addSubview(myIcon)
        }
    }
    
    private func getLabel(title: String, font: UIFont) -> UILabel{
        
        let lableSize = sizeWithText(title, font: font, maxSize: CGSize(width: Width/2, height: 44))
        let label = UILabel()
        label.frame.size = CGSize(width: lableSize.width+4, height: lableSize.height)
        label.backgroundColor = UIColor.white
        label.font = font
        label.textAlignment = .left
        label.text = title
        
        return label
    }


}
