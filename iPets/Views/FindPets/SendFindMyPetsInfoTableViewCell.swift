//
//  SendFindMyPetsInfoTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/30.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SendFindMyPetsInfoTableViewCell: UITableViewCell {
    
    var sendInfoItem: SendFindMyPetInfoModel!
    var delegate: SendFindMyPetsInfoCellViewDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: SendFindMyPetInfoModel, reuseIdentifier cellId:String){
        self.sendInfoItem = data
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    //点击处理
    func selectedAddMorePic(){
        self.delegate?.addMorePic()
    }
    
    func rebuildCell(){
        if(sendInfoItem.name == ""){
            let singleWidth = (Width - 70)/4
            //输入栏图片
            for i in 0 ..< sendInfoItem.pics.count+1 {
                
                let myPic = UIImageView(frame: CGRect(x: 20+(singleWidth+10)*CGFloat(Int(i%4)), y: 100*CGFloat(Int(i/4)+1), width: singleWidth, height: singleWidth))
                myPic.backgroundColor = UIColor.clearColor()
                myPic.layer.masksToBounds = true //不然设置边角没用
                
                //先显示用户的图，在现实加号
                if i < sendInfoItem.pics.count {
                    myPic.image = sendInfoItem.pics[i]
                    self.addSubview(myPic)
                }else if i == sendInfoItem.pics.count && i < 9{
                    //给add按钮添加点击事件
                    myPic.image = UIImage(named: "addMore")
                    myPic.userInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: self, action: #selector(SendFindMyPetsInfoTableViewCell.selectedAddMorePic))
                    myPic.addGestureRecognizer(tap)
                    self.addSubview(myPic)
                }
            }
        }
        
        if(sendInfoItem.name != ""){
            //普通设置栏-头像
            let infoIcon = UIImageView(frame: CGRect(x: 20, y: 7, width: 30, height: 30))
            infoIcon.backgroundColor = UIColor.clearColor()
            infoIcon.image = UIImage(named: sendInfoItem.icon)
            infoIcon.layer.cornerRadius = 0
            self.addSubview(infoIcon)
            //普通设置栏-title
            let titleSize = sizeWithText(sendInfoItem.name, font: sendPageNameFont, maxSize: CGSize(width: Width/2, height: infoIcon.frame.height))
            let title = UILabel(frame: CGRect(x: infoIcon.frame.maxX+10, y: infoIcon.frame.origin.y, width: titleSize.width, height: infoIcon.frame.height))
            title.backgroundColor = UIColor.whiteColor()
            title.font = sendPageNameFont
            title.textAlignment = .Left
            title.text = sendInfoItem.name
            self.addSubview(title)
            //普通设置栏-lable
            let lableSize = sizeWithText(sendInfoItem.lable, font: sendPageLableFont, maxSize: CGSize(width: Width/2, height: infoIcon.frame.height))
            let lable = UILabel(frame: CGRect(x: Width-lableSize.width-40, y: infoIcon.frame.origin.y, width: lableSize.width, height: title.frame.height))
            lable.backgroundColor = UIColor.whiteColor()
            lable.font = sendPageLableFont
            lable.textAlignment = .Right
            lable.text = sendInfoItem.lable
            self.addSubview(lable)
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
