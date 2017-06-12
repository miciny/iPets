//
//  FindPetsMoreView.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/12.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

protocol FindPetsMoreViewDelegate {
    
    func like(index: Int)
    
    func commend(index: Int)
}

class FindPetsMoreView: UIView {
    
    static let shared = FindPetsMoreView.init()
    
    var index: Int?
    var delegate: FindPetsMoreViewDelegate?

    private init() {
        super.init(frame: CGRect.zero)
        
        self.frame.size = CGSize(width: 150, height: 44)
        self.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        
        self.layer.cornerRadius = 5
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView(){
        let likeView = UIImageView(frame: CGRect(x: 15, y: 12, width: 20, height: 20))
        likeView.image = #imageLiteral(resourceName: "Like")
        self.addSubview(likeView)
        
        let likeBtn = UIButton(frame: CGRect(x: likeView.maxXX, y: 7, width: 25, height: 30))
        likeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        likeBtn.setTitle("赞", for: .normal)
        likeBtn.setTitleColor(UIColor.white, for: .normal)
        likeBtn.addTarget(self, action: #selector(self.like), for: .touchUpInside)
        self.addSubview(likeBtn)
        
        let lineView = UIView(frame: CGRect(x: 75, y: 5, width: 1, height: 34))
        lineView.backgroundColor = UIColor.black
        self.addSubview(lineView)
        
        let commendView = UIImageView(frame: CGRect(x: 80, y: 12, width: 20, height: 20))
        commendView.image = #imageLiteral(resourceName: "Commend")
        self.addSubview(commendView)
        
        let commendBtn = UIButton(frame: CGRect(x: commendView.maxXX, y: 7, width: 35, height: 30))
        commendBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        commendBtn.setTitle("评论", for: .normal)
        commendBtn.addTarget(self, action: #selector(self.commend), for: .touchUpInside)
        commendBtn.setTitleColor(UIColor.white, for: .normal)
        self.addSubview(commendBtn)
    }
    
    @objc private func like(){
        self.delegate?.like(index: index!)
    }
    
    @objc private func commend(){
        self.delegate?.commend(index: index!)
    }
}
