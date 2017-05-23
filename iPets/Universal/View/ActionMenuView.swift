//
//  ActionMenuView.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/6.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class ActionMenuView: UIView {

    fileprivate var delegate : actionMenuViewDelegate? // 代理

    fileprivate var frameMarginSize: CGFloat! = 20 //与周围的边距
    fileprivate var frameSize:CGSize = CGSize(width: Width-40, height: 60) //大小
    fileprivate let buttonView = UIView() //装button的View
    
    //可设置项
    var eventFlag = 0 //一个界面多次调用时，进行的判断，可以传入按钮的tag等
    var objectHeight : CGFloat = 50 //每个菜单的高度高度
    var objectFont : CGFloat = 15  //字体
    var objectColor = UIColor.white //字体颜色
    var gap : CGFloat = 10  //间距
    var triCenter = CGPoint() //小三角的位置，就是指示箭头
    
    
    //返回字体的size
    func sizeWithString(_ string:NSString, font:UIFont)->CGSize {
        let dic:NSDictionary = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let options = NSStringDrawingOptions.truncatesLastVisibleLine
        let rect:CGRect = string.boundingRect(with: frameSize, options:options, attributes: dic as? [String : AnyObject], context: nil)
        return rect.size
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(object: NSDictionary, center: CGPoint, target: actionMenuViewDelegate, showInView: UIView){
        self.init()
        
        //获取最大长度
        var size = CGSize(width: 0, height: 0)
        for title in object.allKeys{
            let sizeTmp = self.sizeWithString(title as! String as NSString, font: UIFont.systemFont(ofSize: objectFont))
            if(size.width < sizeTmp.width){
                size = sizeTmp
            }
        }
        
        let totalHeight = CGFloat(object.count) * objectHeight //总高度
        let totalWidth = size.width + objectHeight + gap //总宽度
        var centerPosition = CGPoint()
        
        //超出边界的处理
        var marginX = center.x
        var marginY = center.y
        if(center.x + totalWidth/2 > Width-5){
            marginX = Width-totalWidth/2-5
        }else if(center.x < totalWidth/2+5){
            marginX = totalWidth/2 + 5
        }
        if(center.y + totalHeight/2 > Height-5){
            marginY = Height - totalHeight/2 - 5
        }else if(center.y < totalHeight/2+5){
            marginY = totalHeight/2+5
        }
        centerPosition = CGPoint(x: marginX, y: marginY)
        
        // 自我背景
        self.frame = CGRect(x: 0, y: 0, width: Width, height: Height)
        self.backgroundColor = UIColor.clear  //背景色
        self.isOpaque = true
        self.delegate = target
        self.alpha = 1
        
        //点击其他区域，消失的功能
        let removeBtn = UIButton(frame: CGRect(x: 0 , y: 0, width: Width, height: Height))
        removeBtn.backgroundColor = UIColor.clear
        removeBtn.addTarget(self, action: #selector(ActionMenuView.hideView), for: .touchUpInside)
        self.addSubview(removeBtn)
        
        //装button的view
        buttonView.frame = CGRect(x: 0, y: 0 , width: totalWidth, height: totalHeight)
        buttonView.backgroundColor = UIColor.black
        buttonView.layer.cornerRadius = 3
        buttonView.alpha = 1
        self.addSubview(buttonView)
        
        //循环加载按钮
        if(object.count > 0){
            let lineW : CGFloat = 0.3
            for i in 0 ..< object.count{
                //每个button的分割线
                if(i>0){
                    let cancelLine = UIView(frame: CGRect(x: 0, y: CGFloat(i) * objectHeight, width: totalWidth, height: lineW))
                    cancelLine.backgroundColor = UIColor.white
                    cancelLine.alpha = 0.3
                    buttonView.addSubview(cancelLine)
                }
                
                //每个按钮标题
                let objectLb = UILabel(frame: CGRect(x: objectHeight , y: CGFloat(i) * objectHeight + lineW, width: totalWidth-objectHeight, height: objectHeight-lineW))
                objectLb.backgroundColor = UIColor.clear
                objectLb.text = object.allKeys[i] as? String
                objectLb.font = UIFont.systemFont(ofSize: objectFont)
                objectLb.textColor = objectColor
                buttonView.addSubview(objectLb)
                
                //每个按钮的图片，可能没有
                let images = UIImageView(frame: CGRect(x: gap, y: CGFloat(i) * objectHeight+gap + lineW, width: objectHeight-gap*2, height: objectHeight-gap*2))
                images.image = UIImage(named: (object.allValues[i] as? String)!)
                buttonView.addSubview(images)
                
                //方便点击，不然点击图片难弄
                let objectBtn = UIButton(frame: CGRect(x: 0 , y: CGFloat(i) * objectHeight + lineW, width: totalWidth, height: objectHeight-lineW))
                objectBtn.backgroundColor = UIColor.clear
                objectBtn.addTarget(self, action: #selector(ActionMenuView.buttonClicked(_:)), for: .touchUpInside)
                objectBtn.tag = i
                buttonView.addSubview(objectBtn)
            }
        }
        
        self.buttonView.center = CGPoint(x: centerPosition.x, y: centerPosition.y)
        
        //小三角，先不考虑方向了和位置了
        let tri = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: buttonView.frame.maxX-30, y: buttonView.frame.origin.y))
        bezier.addLine(to: CGPoint(x: buttonView.frame.maxX-23, y: buttonView.frame.origin.y-8))
        bezier.addLine(to: CGPoint(x: buttonView.frame.maxX-16, y: buttonView.frame.origin.y))
        tri.path = bezier.cgPath
        tri.fillColor = UIColor.black.cgColor
        tri.strokeColor = UIColor.black.cgColor
        self.layer.addSublayer(tri)
        
        //动画
        let animation = viewPresentAnimation()
        showInView.addSubview(self)
        self.layer.add(animation, forKey: "")
        
    }
    
    //隐藏
    func hideView(){
        UIView.animate(withDuration: 0.2, animations: {
            () -> ()in
            self.alpha = 0
            }, completion: {
                (Boolean) -> ()in
                self.removeFromSuperview()
        })
    }
    
    //动画
    fileprivate func viewPresentAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = CGFloat(0)
        animation.toValue = CGFloat(self.alpha)
        animation.duration = 0.3
        
        return animation
    }
    
    //点击事件的代理
    @objc fileprivate func buttonClicked(_ sender : UIButton){
        hideView()
        self.delegate?.menuClicked(sender.tag, eventFlag: self.eventFlag)
    }
}
