//
//  PrizeArea.swift
//  Roll
//
//  Created by maocaiyuan on 2017/1/13.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class PrizeAreaView: UIView {
    //中奖区
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 10, y: 10, width: Width-20, height: RollConstans._width+40)
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //显示中奖头像
    func showPrizeIcon(_ view: UIView, selectedManArray: NSMutableArray){
        let subViews = view.subviews
        for sub in subViews{
            sub.removeFromSuperview()
        }
        
        let count = selectedManArray.count
        let gap = (Width - 20 - RollConstans._width * CGFloat(count)) / CGFloat(count + 1)
        
        for i in 0 ..< count {
            let man = iconImageView()  //显示图片
            let originX = gap + CGFloat(Int(i%count)) * (RollConstans._width + gap)
            let originY = 10 + CGFloat(Int(i/count)) * (RollConstans._width + gap)
            man.frame.origin = CGPoint(x: originX, y: originY)
            
            let manId = selectedManArray[i]
            man.image = UIImage(named: "icon_"+String(describing: manId)+".JPG")
            view.addSubview(man)
            
            //显示名字
            let manName = RollViewLike.nameLb()
            manName.frame.origin = CGPoint(x: originX, y: man.frame.maxY)
            manName.text = RollConstans.manArray[manId as! Int]
            view.addSubview(manName)
        }
    }

//==============================================样式================================
    //人员的头像
    func iconImageView() -> UIImageView{
        let icon = UIImageView()
        icon.frame.size = CGSize(width: RollConstans._width, height: RollConstans._width)
        icon.backgroundColor = UIColor.lightGray
        icon.layer.cornerRadius = 5
        icon.layer.masksToBounds = true
        return icon
    }
}
