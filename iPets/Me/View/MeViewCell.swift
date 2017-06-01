//
//  SettingTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MeViewCell: UITableViewCell {
    
    var meItem: MeDataModel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: MeDataModel, reuseIdentifier cellId: String){
        
        self.meItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    func rebuildCell(){
        if(meItem.lable == nil){
            
            //个人设置栏-头像  高度 100
            let myIcon = UIImageView(frame: CGRect(x: 20, y: 20, width: 60, height: 60))
            myIcon.backgroundColor = UIColor.gray
            myIcon.layer.masksToBounds = true //不然设置边角没用
            myIcon.layer.cornerRadius = 5
            myIcon.image = meItem.pic
            self.addSubview(myIcon)
            
            //个人设置栏-名字
            let myName = getLabel(title: meItem.name!, font: settingPageNameFont)
            myName.frame.origin = CGPoint(x: myIcon.frame.maxX+10, y: myIcon.frame.minY)
            self.addSubview(myName)
            
            //个人设置栏-寻宠昵称
            let myNickname = getLabel(title: "寻宠号：" + meItem.nickname!, font: settingPageLabelFont)
            myNickname.frame.origin = CGPoint(x: myIcon.frame.maxX+10, y: myIcon.frame.midY)
            self.addSubview(myNickname)
            
            //个人设置栏-二维码图片
            let my2DIcon = UIImageView(frame: CGRect(x: Width-60, y: myIcon.frame.height/2+10, width: 20, height: 20))
            my2DIcon.backgroundColor = UIColor.clear
            my2DIcon.image = UIImage(named: meItem.TDicon!)
            my2DIcon.layer.cornerRadius = 1
            self.addSubview(my2DIcon)
        }
        
        if(meItem.name == nil){
            
            //普通设置栏-头像 高度44
            let myIcon = UIImageView(frame: CGRect(x: 20, y: 7, width: 30, height: 30))
            myIcon.backgroundColor = UIColor.clear
            myIcon.image = UIImage(named: meItem.icon!)
            myIcon.layer.cornerRadius = 0
            self.addSubview(myIcon)
            
            //普通设置栏-title
            let title = getLabel(title: meItem.lable!, font: settingPageLabelFont)
            title.frame.origin.x = myIcon.frame.maxX+10
            title.center.y = myIcon.frame.midY
            self.addSubview(title)
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
