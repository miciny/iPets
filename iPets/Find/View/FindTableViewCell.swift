//
//  FindTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/9.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class FindTableViewCell: UITableViewCell {

    var findItem: FindDataModel!
    private var bageView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: FindDataModel, reuseIdentifier cellId: String){
        self.findItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        
        rebuildCell()
    }
    
    func rebuildCell(){
        
        //普通设置栏-title
        let title = getLabel(title: findItem.title, font: findPageLabelFont)
        title.frame.origin.x = 60
        title.center.y = 22
        self.addSubview(title)
        
        
        //普通设置栏-头像 高度44
        let myIcon = UIImageView(frame: CGRect(x: 20, y: 7, width: 30, height: 30))
        myIcon.backgroundColor = UIColor.clear
        myIcon.image = UIImage(named: findItem.icon)
        self.addSubview(myIcon)
        
        
        if let image = findItem.leftIcon{
            //普通设置栏-头像 高度44
            let leftIcon = UIImageView(frame: CGRect(x: Width-65, y: 5, width: 34, height: 34))
            leftIcon.backgroundColor = UIColor.clear
            leftIcon.image = image
            self.addSubview(leftIcon)
            
            bageView = BageValueView.redDotView(10)
            bageView!.center = CGPoint(x: leftIcon.maxXX-2, y: leftIcon.y+2)
            self.addSubview(bageView!)
        }
    }
    
    private func getLabel(title: String, font: UIFont) -> UILabel{
        
        let lableSize = sizeWithText(title, font: font, maxSize: CGSize(width: Width/2, height: 44))
        let label = UILabel()
        label.frame.size = CGSize(width: lableSize.width+4, height: lableSize.height)
        label.backgroundColor = UIColor.white
        label.font = font
        label.textAlignment = .left
        label.text = title
        
        return label
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        let originColor = bageView?.backgroundColor
        super.setSelected(selected, animated: animated)
        bageView?.backgroundColor = originColor
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
        let originColor = bageView?.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        bageView?.backgroundColor = originColor
    }

}
