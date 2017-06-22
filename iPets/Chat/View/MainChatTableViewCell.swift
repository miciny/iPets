//
//  MainChatTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/24.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class MainChatTableViewCell: UITableViewCell {
    
    var mainChatItem: MainChatListViewDataModel!
    let chatIcon = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: MainChatListViewDataModel, reuseIdentifier cellId: String){
        self.mainChatItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        rebuildCell()
    }
    
    func rebuildCell(){
        //聊天栏，图片
        chatIcon.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        chatIcon.backgroundColor = UIColor.gray
        chatIcon.layer.masksToBounds = true //不然设置边角没用
        chatIcon.layer.cornerRadius = 5
        if let pic = self.mainChatItem.pic{
            self.chatIcon.image = pic
        }
        self.addSubview(chatIcon)
        
        //聊天栏，名字
        let nameSize = sizeWithText(self.mainChatItem.name, font: chatListPageTitleFont, maxSize: CGSize(width: Width*2/3, height: chatIcon.frame.height/2))
        let chatName = UILabel(frame: CGRect(x: chatIcon.frame.maxX+10, y: chatIcon.frame.origin.y,
            width: nameSize.width, height: chatIcon.frame.height/2).integral)
        chatName.backgroundColor = UIColor.white
        chatName.font = chatListPageTitleFont
        chatName.textColor = UIColor.black
        chatName.textAlignment = .left
        chatName.text = mainChatItem.name
        self.addSubview(chatName)
        
        //聊天栏，文字
        if let labelStr = self.mainChatItem.lable{
            
            let textSize = sizeWithText(labelStr, font: chatListPageTextFont,
                                        maxSize: CGSize(width: self.frame.width-40, height: chatIcon.frame.height/2))
            let chatLb = UILabel(frame: CGRect(x: chatIcon.frame.maxX+10, y: chatIcon.frame.origin.y+chatIcon.frame.height/2,
                                               width: textSize.width, height: chatIcon.frame.height/2).integral)
            chatLb.backgroundColor = UIColor.white
            chatLb.font = chatListPageTextFont
            chatLb.textColor = UIColor.gray
            chatLb.textAlignment = .left
            chatLb.text = labelStr
            self.addSubview(chatLb)
            
            //聊天栏，时间
            let str = DateToToString.getChatListTimeFormat(mainChatItem.time)
            let timeSize = sizeWithText(str, font: chatListPageTimeFont, maxSize: CGSize(width: Width-chatName.frame.maxX-10, height: chatIcon.frame.height/2))
            let chatTimeLb = UILabel(frame: CGRect(x: Width-timeSize.width-10, y: chatIcon.frame.origin.y,
                                    width: timeSize.width, height: timeSize.height+4).integral) //解决多一条线的问题
            chatTimeLb.backgroundColor = UIColor.white
            chatTimeLb.font = chatListPageTimeFont
            chatTimeLb.textColor = UIColor.gray
            chatTimeLb.textAlignment = .center
            chatTimeLb.text = str
            self.addSubview(chatTimeLb)
        }
        
        if mainChatItem.unreadCount > 0{
            let bageView = BageValueView.nbView(str: String(mainChatItem.unreadCount))
            bageView.center = CGPoint(x: chatIcon.maxXX-5, y: chatIcon.y+5)
            self.addSubview(bageView)
        }
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
