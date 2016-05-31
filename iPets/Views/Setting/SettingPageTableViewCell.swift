//
//  SettingPageTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SettingPageTableViewCell: UITableViewCell {
    
    var settingItem: SettingPageModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: SettingPageModel, reuseIdentifier cellId:String){
        self.settingItem = data
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    //重新调整cell的数据布局
    func rebuildCell(){
        
        //个人信息页-title
        let nameSize = sizeWithText(settingItem.name, font: settingPageNameFont, maxSize: CGSize(width: Width/2, height: self.frame.height))
        let myName = UILabel(frame: CGRect(x: 20, y: 0, width: nameSize.width, height: 44))
        myName.backgroundColor = UIColor.whiteColor()
        myName.font = settingPageNameFont
        myName.textAlignment = .Left
        myName.text = settingItem.name
        self.addSubview(myName)
        
        if(settingItem.pic != nil || settingItem.lable != nil){
            //设置 帐号
            let lableSize = sizeWithText(settingItem.lable!, font: settingPageLableFont, maxSize: CGSize(width: Width-myName.frame.maxX-50, height: self.frame.height))
            let leble = UILabel(frame: CGRect(x: Width-lableSize.width-40, y: 0, width: lableSize.width, height: self.frame.height))
            leble.backgroundColor = UIColor.whiteColor()
            leble.font = settingPageLableFont
            leble.textAlignment = .Right
            leble.text = settingItem.lable
            self.addSubview(leble)
        }
        
    }

}
