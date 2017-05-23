//
//  MainChatTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/24.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MainChatTableViewCell: UITableViewCell {
    
    var mainChatItem: MainChatModel!
    let chatIcon = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: MainChatModel, reuseIdentifier cellId:String){
        self.mainChatItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    func rebuildCell(){
        //聊天栏，图片
        chatIcon.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        chatIcon.backgroundColor = UIColor.gray
        chatIcon.layer.masksToBounds = true //不然设置边角没用
        chatIcon.layer.cornerRadius = 5
        self.chatIcon.image = self.mainChatItem.pic
        self.addSubview(chatIcon)
        
        //聊天栏，名字
        let nameSize = sizeWithText(self.mainChatItem.name as NSString, font: chatListPageTitleFont, maxSize: CGSize(width: Width*2/3, height: chatIcon.frame.height/2))
        let chatName = UILabel(frame: CGRect(x: chatIcon.frame.maxX+10, y: chatIcon.frame.origin.y,
            width: nameSize.width, height: chatIcon.frame.height/2))
        chatName.backgroundColor = UIColor.white
        chatName.font = chatListPageTitleFont
        chatName.textColor = UIColor.black
        chatName.textAlignment = .left
        chatName.text = mainChatItem.name
        self.addSubview(chatName)
        
        //聊天栏，文字
        let textSize = sizeWithText(self.mainChatItem.lable as NSString, font: chatListPageTextFont, maxSize: CGSize(width: self.frame.width, height: chatIcon.frame.height/2))
        let chatLb = UILabel(frame: CGRect(x: chatIcon.frame.maxX+10, y: chatIcon.frame.origin.y+chatIcon.frame.height/2,
            width: textSize.width, height: chatIcon.frame.height/2))
        chatLb.backgroundColor = UIColor.white
        chatLb.font = chatListPageTextFont
        chatLb.textColor = UIColor.gray
        chatLb.textAlignment = .left
        chatLb.text = mainChatItem.lable
        self.addSubview(chatLb)
        
        //聊天栏，时间
        let str = DateToToString.getChatListTimeFormat(mainChatItem.time)
        let timeSize = sizeWithText(str as NSString, font: chatListPageTimeFont, maxSize: CGSize(width: Width-chatName.frame.maxX-10, height: chatIcon.frame.height/2))
        let chatTimeLb = UILabel(frame: CGRect(x: Width-timeSize.width-10, y: chatIcon.frame.origin.y,
            width: timeSize.width, height: chatIcon.frame.height/2))
        chatTimeLb.backgroundColor = UIColor.white
        chatTimeLb.font = chatListPageTimeFont
        chatTimeLb.textColor = UIColor.gray
        chatTimeLb.textAlignment = .right
        chatTimeLb.text = str
        self.addSubview(chatTimeLb)
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
