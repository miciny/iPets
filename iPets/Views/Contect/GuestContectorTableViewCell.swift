//
//  GuestContectorTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/28.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class GuestContectorTableViewCell: UITableViewCell {
    
    var contectItem: GuestContectorInfoModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: GuestContectorInfoModel, reuseIdentifier cellId:String){
        self.contectItem = data
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    func rebuildCell(){
        //获取最大的宽度
        let maxSize = sizeWithText("个人相册", font: gusetTextFont, maxSize: CGSize(width: Width/2, height: 1000))
        
        if(contectItem.name != ""){
            //个人详细资料页的头像
            let thisIcon = UIImageView(frame: CGRect(x: 20, y: 20, width: 60, height: 60))
            thisIcon.backgroundColor = UIColor.grayColor()
            thisIcon.layer.masksToBounds = true //不然设置边角没用
            thisIcon.layer.cornerRadius = 5
            thisIcon.image = contectItem.icon
            self.addSubview(thisIcon)
            //个人详细资料页的名字
            let thisNameSize = sizeWithText(contectItem.name + "(" + contectItem.sex + ")", font: gusetNameFont, maxSize: CGSize(width: Width/2, height: 1000))
            let thisName = UILabel(frame: CGRect(x: thisIcon.frame.maxX+10, y: thisIcon.frame.origin.y, width: thisNameSize.width, height: thisIcon.frame.height/2))
            thisName.backgroundColor = UIColor.whiteColor()
            thisName.font = gusetNameFont
            thisName.textAlignment = .Left
            thisName.text = contectItem.name + "(" + contectItem.sex + ")"
            self.addSubview(thisName)
            //个人详细资料页的寻宠昵称
            let thisNicknameSize = sizeWithText("寻宠号："+contectItem.nickname, font: gusetLabelFont, maxSize: CGSize(width: Width/2, height: 1000))
            let thisNickname = UILabel(frame: CGRect(x: thisIcon.frame.maxX+10, y: thisIcon.frame.origin.y+thisIcon.frame.height/2, width: thisNicknameSize.width, height: thisIcon.frame.height/2))
            thisNickname.backgroundColor = UIColor.whiteColor()
            thisNickname.font = gusetLabelFont
            thisNickname.textAlignment = .Left
            thisNickname.text = "寻宠号："+contectItem.nickname
            self.addSubview(thisNickname)
        }else if(contectItem.remark != ""){
            //
            let remarkLb = UILabel(frame: CGRect(x: 20, y: 7, width: maxSize.width, height: 30))
            remarkLb.backgroundColor = UIColor.clearColor()
            remarkLb.textAlignment = .Left
            remarkLb.font = gusetTextFont
            remarkLb.text = "标签"
            self.addSubview(remarkLb)
            //
            let thisRemark = UILabel(frame: CGRect(x: remarkLb.frame.maxX+10, y: remarkLb.frame.origin.y, width: Width/2, height: remarkLb.frame.height))
            thisRemark.backgroundColor = UIColor.whiteColor()
            thisRemark.font = gusetLabelFont
            thisRemark.textAlignment = .Left
            thisRemark.text = contectItem.remark
            self.addSubview(thisRemark)
        }else if(contectItem.address != ""){
            //
            let addressLb = UILabel(frame: CGRect(x: 20, y: 7, width: maxSize.width, height: 30))
            addressLb.backgroundColor = UIColor.clearColor()
            addressLb.font = gusetTextFont
            addressLb.textAlignment = .Left
            addressLb.text = "地区"
            self.addSubview(addressLb)
            //
            let thisAddress = UILabel(frame: CGRect(x: addressLb.frame.maxX+10, y: addressLb.frame.origin.y, width: Width/2, height: addressLb.frame.height))
            thisAddress.backgroundColor = UIColor.whiteColor()
            thisAddress.font = gusetLabelFont
            thisAddress.textAlignment = .Left
            thisAddress.text = contectItem.address
            self.addSubview(thisAddress)
        }else if(contectItem.http != ""){
            //
            let httpLb = UILabel(frame: CGRect(x: 20, y: 30, width: maxSize.width, height: 30))
            httpLb.backgroundColor = UIColor.clearColor()
            httpLb.font = gusetTextFont
            httpLb.textAlignment = .Left
            httpLb.text = "个人相册"
            self.addSubview(httpLb)
            //
            let thisHttp = UILabel(frame: CGRect(x: httpLb.frame.maxX+10, y: httpLb.frame.origin.y, width: Width/2, height: httpLb.frame.height))
            thisHttp.backgroundColor = UIColor.whiteColor()
            thisHttp.font = gusetLabelFont
            thisHttp.textAlignment = .Left
            thisHttp.text = contectItem.http
            self.addSubview(thisHttp)
        }
       
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
