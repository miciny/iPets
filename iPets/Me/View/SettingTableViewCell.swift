//
//  SettingTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    var settingItem: SettingDataModel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: SettingDataModel, reuseIdentifier cellId:String){
        self.settingItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    func rebuildCell(){
        if(settingItem.lable == ""){
            //个人设置栏-头像
            let myIcon = UIImageView(frame: CGRect(x: 20, y: 20, width: 60, height: 60))
            myIcon.backgroundColor = UIColor.gray
            myIcon.layer.masksToBounds = true //不然设置边角没用
            myIcon.layer.cornerRadius = 5
            myIcon.image = settingItem.pic
            self.addSubview(myIcon)
            //个人设置栏-名字
            let nameSize = sizeWithText(settingItem.name as NSString, font: settingPageNameFont, maxSize: CGSize(width: Width/2, height: myIcon.frame.height/2))
            let myName = UILabel(frame: CGRect(x: myIcon.frame.maxX+10, y: myIcon.frame.origin.y, width: nameSize.width, height: myIcon.frame.height/2))
            myName.backgroundColor = UIColor.white
            myName.font = settingPageNameFont
            myName.textAlignment = .left
            myName.text = settingItem.name
            self.addSubview(myName)
            //个人设置栏-寻宠昵称
            let nicknameSize = sizeWithText("寻宠号："+settingItem.nickname as NSString, font: settingPageLableFont, maxSize: CGSize(width: Width/2, height: myIcon.frame.height/2))
            let myNickname = UILabel(frame: CGRect(x: myIcon.frame.maxX+10, y: myIcon.frame.origin.y+myIcon.frame.height/2, width: nicknameSize.width, height: myIcon.frame.height/2))
            myNickname.backgroundColor = UIColor.white
            myNickname.font = settingPageLableFont
            myNickname.textAlignment = .left
            myNickname.text = "寻宠号："+settingItem.nickname
            self.addSubview(myNickname)
            //个人设置栏-二维码图片
            let my2DIcon = UIImageView(frame: CGRect(x: Width-60, y: myIcon.frame.height/2+10, width: 20, height: 20))
            my2DIcon.backgroundColor = UIColor.clear
            my2DIcon.image = UIImage(named: settingItem.TDicon)
            my2DIcon.layer.cornerRadius = 1
            self.addSubview(my2DIcon)
        }
        
        if(settingItem.name == ""){
            //普通设置栏-头像
            let myIcon = UIImageView(frame: CGRect(x: 20, y: 7, width: 30, height: 30))
            myIcon.backgroundColor = UIColor.clear
            myIcon.image = UIImage(named: settingItem.icon)
            myIcon.layer.cornerRadius = 0
            self.addSubview(myIcon)
            //普通设置栏-title
            let lableSize = sizeWithText(settingItem.lable as NSString, font: settingPageNameFont, maxSize: CGSize(width: Width/2, height: myIcon.frame.height))
            let title = UILabel(frame: CGRect(x: myIcon.frame.maxX+10, y: myIcon.frame.origin.y, width: lableSize.width, height: myIcon.frame.height))
            title.backgroundColor = UIColor.white
            title.font = settingPageNameFont
            title.textAlignment = .left
            title.text = settingItem.lable
            self.addSubview(title)
        }
        
    }

}
