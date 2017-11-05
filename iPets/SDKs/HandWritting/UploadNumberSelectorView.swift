//
//  UploadNumberSelectorView.swift
//  iPets
//
//  Created by maocaiyuan on 2017/8/3.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit


protocol UploadNumberSelectorViewDelegate{
    func setNumber(i: Int)
}

class UploadNumberSelectorView: UIView {

    private var delegate: UploadNumberSelectorViewDelegate?
    
    init(frame: CGRect, delegate: UploadNumberSelectorViewDelegate) {
        super.init(frame: frame)
        self.delegate = delegate
        
        self.backgroundColor = UIColor.darkGray
        self.setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setView(){
        
        let w = Width/5
        let g = w/4
        
        for i in 0 ..< 10{
            let ii = CGFloat(i)
            let x = (ii.truncatingRemainder(dividingBy: 3) * (w+g)) + g*3
            let y = (CGFloat(i/3) * (w+g)) + g*5
            
            let btn = UIButton(frame: CGRect(x: x, y: y, width: w, height: w))
            btn.tag = i
            btn.addTarget(self, action: #selector(self.tabBtn(_:)), for: .touchUpInside)
            btn.setTitle("\(i)", for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.backgroundColor = UIColor.lightGray
            self.addSubview(btn)
        }
    }
    
    @objc func tabBtn(_ sender: UIButton){
        let i = sender.tag
        self.delegate?.setNumber(i: i)
        self.dismiss()
    }
    
    func dismiss(){
        self.removeFromSuperview()
    }

}
