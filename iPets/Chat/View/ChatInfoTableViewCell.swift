//
//  ChatInfoTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

protocol ChatInfoTableViewCellDelegate {
    
}


class ChatInfoTableViewCell: UITableViewCell{

    var contectItem: ChatInfoViewDataModel!
    var delegate: ChatInfoTableViewCellDelegate?
    var topSwitch: UISwitch?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: ChatInfoViewDataModel, reuseIdentifier cellId: String){
        self.contectItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    func rebuildCell(){
        //获取最大的宽度
        
        if let name = contectItem.name{
            //个人详细资料页的头像
            let thisIcon = UIImageView(frame: CGRect(x: 20, y: 10, width: 60, height: 60))
            thisIcon.backgroundColor = UIColor.gray
            thisIcon.layer.masksToBounds = true //不然设置边角没用
            thisIcon.layer.cornerRadius = 5
            thisIcon.image = contectItem.icon!
            self.addSubview(thisIcon)
            
            //个人详细资料页的名字
            let nameStr = name
            let thisName = getLabel(str: nameStr, font: gusetLabelFont)
            thisName.frame.origin.y = thisIcon.frame.maxY+3
            thisName.center.x = thisIcon.center.x
            thisName.textAlignment = .center
            self.addSubview(thisName)
        }
        
        if let label = contectItem.label{
            //
            let remarkLb = getLabel(str: label, font: gusetNameFont)
            remarkLb.frame.origin.x = 20
            remarkLb.center.y = self.height/2
            self.addSubview(remarkLb)
            
            if let isSwitch = contectItem.isSwitch{
                
                topSwitch = UISwitch()
                topSwitch!.frame.size = CGSize(width: 20, height: 20)
                topSwitch!.frame.origin.x = self.width-10
                topSwitch!.center.y = self.height/2
                topSwitch!.isOn = isSwitch
                self.addSubview(topSwitch!)
                
            }else{
                self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        }
    }
       
    private func getLabel(str: String, font: UIFont) -> UILabel{
        let maxSize = sizeWithText(str, font: font, maxSize: CGSize(width: Width/2, height: 30))
        
        let lb = UILabel()
        lb.frame.size = CGSize(width: maxSize.width, height: maxSize.height)
        lb.backgroundColor = UIColor.clear
        lb.font = font
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
