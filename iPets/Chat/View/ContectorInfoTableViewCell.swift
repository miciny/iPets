//
//  GuestContectorTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/28.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ContectorInfoTableViewCell: UITableViewCell {
    
    var contectItem: ContectorInfoViewDataModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: ContectorInfoViewDataModel, reuseIdentifier cellId:String){
        self.contectItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    func rebuildCell(){
        //获取最大的宽度
        
        if let name = contectItem.name{
            //个人详细资料页的头像
            let thisIcon = UIImageView(frame: CGRect(x: 20, y: 20, width: 60, height: 60))
            thisIcon.backgroundColor = UIColor.gray
            thisIcon.layer.masksToBounds = true //不然设置边角没用
            thisIcon.layer.cornerRadius = 5
            thisIcon.image = contectItem.icon!
            self.addSubview(thisIcon)
            
            //个人详细资料页的名字
            let nameStr = name + "(" + contectItem.sex! + ")"
            let thisNameSize = sizeWithText(nameStr, font: gusetNameFont, maxSize: CGSize(width: Width/2, height: 1000))
            let thisName = UILabel(frame: CGRect(x: thisIcon.frame.maxX+10, y: thisIcon.frame.origin.y, width: thisNameSize.width, height: thisIcon.frame.height/2))
            thisName.backgroundColor = UIColor.white
            thisName.font = gusetNameFont
            thisName.textAlignment = .left
            thisName.text = nameStr
            self.addSubview(thisName)
            
            //个人详细资料页的寻宠昵称
            let nicknameStr = "寻宠号："+contectItem.nickname!
            let thisNicknameSize = sizeWithText(nicknameStr, font: gusetLabelFont, maxSize: CGSize(width: Width/2, height: 1000))
            let thisNickname = UILabel(frame: CGRect(x: thisIcon.frame.maxX+10, y: thisIcon.frame.origin.y+thisIcon.frame.height/2, width: thisNicknameSize.width, height: thisIcon.frame.height/2))
            thisNickname.backgroundColor = UIColor.white
            thisNickname.font = gusetLabelFont
            thisNickname.textAlignment = .left
            thisNickname.text = nicknameStr
            self.addSubview(thisNickname)
        }
        
        if let remark = contectItem.remark{
            //
            let remarkLb = getLabel(str: "标签")
            remarkLb.frame.origin = CGPoint(x: 20, y: 7)
            self.addSubview(remarkLb)
            //
            let thisRemark = UILabel(frame: CGRect(x: remarkLb.frame.maxX+10, y: remarkLb.frame.origin.y, width: Width/2, height: remarkLb.frame.height))
            thisRemark.backgroundColor = UIColor.white
            thisRemark.font = gusetLabelFont
            thisRemark.textAlignment = .left
            thisRemark.text = remark
            self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            self.addSubview(thisRemark)
        }
        
        if let address = contectItem.address{
            //
            let addressLb = getLabel(str: "地区")
            addressLb.frame.origin = CGPoint(x: 20, y: 7)
            self.addSubview(addressLb)
            //
            let thisAddress = UILabel(frame: CGRect(x: addressLb.frame.maxX+10, y: addressLb.frame.origin.y, width: Width/2, height: addressLb.frame.height))
            thisAddress.backgroundColor = UIColor.white
            thisAddress.font = gusetLabelFont
            thisAddress.textAlignment = .left
            thisAddress.text = address
            self.addSubview(thisAddress)
        }
        
        if let http = contectItem.http{
            //
            let httpLb = getLabel(str: "个人相册")
            httpLb.frame.origin = CGPoint(x: 20, y: 30)
            self.addSubview(httpLb)
            
            //
            let thisHttp = UILabel(frame: CGRect(x: httpLb.frame.maxX+10, y: httpLb.frame.origin.y, width: Width/2, height: httpLb.frame.height))
            thisHttp.backgroundColor = UIColor.white
            thisHttp.font = gusetLabelFont
            thisHttp.textAlignment = .left
            thisHttp.text = http
            self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            self.addSubview(thisHttp)
        }
    }
    
    private func getLabel(str: String) -> UILabel{
        let maxSize = sizeWithText("个人相册", font: gusetTextFont, maxSize: CGSize(width: Width/2, height: 1000))
        
        let lb = UILabel()
        lb.frame.size = CGSize(width: maxSize.width, height: 30)
        lb.backgroundColor = UIColor.clear
        lb.font = gusetTextFont
        lb.textAlignment = .left
        lb.text = str
        
        return lb
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
