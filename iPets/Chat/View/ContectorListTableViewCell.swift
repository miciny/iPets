//
//  ContectorListTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ContectorListTableViewCell: UITableViewCell {
    
    var mainContectorItem: ContectorListModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: ContectorListModel, reuseIdentifier cellId:String){
        self.mainContectorItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    func rebuildCell(){
        //联系人图片
        let contectorIcon = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        contectorIcon.backgroundColor = UIColor.gray
        contectorIcon.layer.masksToBounds = true //不然设置边角没用
        contectorIcon.layer.cornerRadius = 5
        contectorIcon.image = mainContectorItem.icon
        self.addSubview(contectorIcon)
        //联系人，名字
        let contectorNameSize = sizeWithText(mainContectorItem.name as NSString, font: contectorListPageLableFont, maxSize: CGSize(width: Width/2, height: 1000))
        let contectorName = UILabel(frame: CGRect(x: contectorIcon.frame.maxX+10, y: contectorIcon.frame.origin.y,
            width: contectorNameSize.width, height: contectorIcon.frame.height))
        contectorName.backgroundColor = UIColor.white
        contectorName.font = contectorListPageLableFont
        contectorName.textAlignment = .left
        contectorName.text = mainContectorItem.name
        self.addSubview(contectorName)
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
