//
//  PersonInfoTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class PersonInfoTableViewCell: UITableViewCell {
    
    //信息模型
    var infoItem: PersonInfoDataModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //初始化
    init(data: PersonInfoDataModel, reuseIdentifier cellId:String){
        self.infoItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    //重新调整cell的数据布局
    func rebuildCell(){
        
        //个人信息页-title
        let nameSize = sizeWithText(infoItem.name, font: settingPageNameFont, maxSize: CGSize(width: Width/2, height: self.frame.height))
        let myName = UILabel(frame: CGRect(x: 20, y: 0, width: nameSize.width, height: 44))
        myName.backgroundColor = UIColor.white
        myName.font = settingPageNameFont
        myName.textAlignment = .left
        myName.text = infoItem.name
        self.addSubview(myName)
        
        //第一栏，头像栏
        if(infoItem.pic != nil){
            //个人信息页-图像
            myName.frame = CGRect(x: 20, y: 0, width: nameSize.width, height: 100) //手动调整下lable的位置
            
            let myIcon = UIImageView(frame: CGRect(x: Width-100, y: 20, width: 60, height: 60))
            myIcon.backgroundColor = UIColor.gray
            myIcon.layer.masksToBounds = true  //不然设置边角没用
            myIcon.layer.cornerRadius = 5
            myIcon.image = infoItem.pic
            self.addSubview(myIcon)
            
        }else if(infoItem.TDicon != nil){
            //个人信息页-二维码
            let myIcon = UIImageView(frame: CGRect(x: Width-60, y: self.frame.height/2-10, width: 20, height: 20))
            myIcon.backgroundColor = UIColor.clear
            myIcon.image = UIImage(named: infoItem.TDicon!)
            myIcon.layer.cornerRadius = 5
            self.addSubview(myIcon)
            
        }else{
            //个人信息页-其他栏
            let lableSize = sizeWithText(infoItem.lable!, font: settingPageLabelFont, maxSize: CGSize(width: Width-myName.frame.maxX-50, height: self.frame.height))
            let leble = UILabel(frame: CGRect(x: Width-lableSize.width-40, y: 0, width: lableSize.width, height: self.frame.height))
            leble.backgroundColor = UIColor.white
            leble.font = settingPageLabelFont
            leble.textColor = UIColor.gray
            leble.textAlignment = .right
            leble.text = infoItem.lable!
            self.addSubview(leble)
        }
    }
}
