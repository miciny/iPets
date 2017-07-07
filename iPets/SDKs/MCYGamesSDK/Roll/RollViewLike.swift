//
//  RollViewLike.swift
//  iPets
//
//  Created by maocaiyuan on 2017/7/7.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class RollViewLike: NSObject {
    
    //==============================================样式================================
    //人员的头像
    class func iconImageView() -> UIImageView{
        let icon = UIImageView()
        icon.frame.size = CGSize(width: RollConstans._width, height: RollConstans._width)
        icon.backgroundColor = UIColor.lightGray
        icon.layer.cornerRadius = 5
        icon.layer.masksToBounds = true
        return icon
    }
    
    class func nameLb() -> UILabel{
        let lb = UILabel()
        lb.frame.size = CGSize(width: RollConstans._width, height: 20)
        lb.font = standardFont
        lb.textAlignment = NSTextAlignment.center
        return lb
    }
    
    //按钮样式
    class func myBtn(_ title: String, color: UIColor) -> UIButton{
        let btn = UIButton()
        btn.frame.size = CGSize(width: Width-40, height: 44)
        btn.backgroundColor = color
        btn.setTitleColor(UIColor.white, for: UIControlState())
        btn.setTitle(title, for: UIControlState())
        btn.layer.cornerRadius = 5
        return btn
    }
    
    //滚动
    class func setUpScrollView() -> UIScrollView{
        let mainScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: Width, height: Height-49))
        mainScroll.backgroundColor = UIColor.white
        mainScroll.showsVerticalScrollIndicator = true
        mainScroll.showsHorizontalScrollIndicator = false
        return mainScroll
    }
    
    //抖动的动画
    class func starAnim(_ view: UIView) {
        // 1:创建动画对象
        let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
        anim.values = [(-3 / 180 * Double.pi), (3 / 180 * Double.pi), (-3 / 180 * Double.pi)]
        anim.repeatCount = Float(MAX_CANON)
        anim.duration = 0.3
        anim.autoreverses = true
        anim.isRemovedOnCompletion = false
        view.layer.add(anim, forKey: nil)
    }
    
    //停止动画
    class func stopAnim(_ view: UIView) {
        view.layer.removeAllAnimations()
    }
    
    
    //去掉作弊人员
    class func cheat(_ count: Int, realManArray: NSMutableArray) -> Int{
        var cheatManName = [String]()
        for i in 0 ..<  RollConstans.manNotInclude.count{  //循环找到要去掉的人
            let index = RollConstans.manNotInclude[i]
            let manCount = RollConstans.manArray.count
            if index > 0 && index < manCount {  //如果没有人的话，默认数是100
                cheatManName.append(RollConstans.manArray[index])
            }
        }
        
        var theManName = ""
        var theMan = 0
        
        if cheatManName.count == 0 || cheatManName.count >= count{
            theMan = getIntRandomNum(count, min: 0)  //随机到的人编号
        }else{
            repeat {
                theMan = getIntRandomNum(count, min: 0)  //随机到的人编号
                let manId = realManArray[theMan]
                theManName = RollConstans.manArray[manId as! Int] //  获取选中的人的名字
                
            }while cheatManName.contains(theManName)
        }
        
        return theMan
    }
    
    
    
    //返回一个数字字符串 0-9
    class func getNoStr() -> String{
        var str = "编号："
        for _ in 0...6{
            let no = getIntRandomNum(10, min: 0)
            str = str + String(no)
        }
        return str
    }
}
