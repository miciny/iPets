//
//  MyCollectionHearderView.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/18.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

// 主页的头图
class SellBuyCollectionHeaderView: UICollectionReusableView, MCYAutoScrollViewDelegate {

    fileprivate var picArray = ["defaultIcon"]
    var delegate: SellBuyHeaderDelegate?
    
    // 主页的头图
    func addHeaderScrollPicsView(_ pic: NSArray){
        picArray = pic as! [String]
        
        let autoScrollView = HeaderCycleView(frame: CGRect(x: 0, y: 0, width: Width, height: Width*0.5))
        autoScrollView.backgroundColor = UIColor.gray
        autoScrollView.delegate = self
        autoScrollView.autoScroll = true
        self.addSubview(autoScrollView)
    }
    
    // 主页的其它头图
    func addHeaderTitleView(_ title: String){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 30))
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        let lable = UILabel(frame: view.frame)
        lable.backgroundColor = UIColor.clear
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 22)
        lable.text = title
        view.addSubview(lable)
        
        self.addSubview(view)
    }
    
    //MARK:- MCYAutoScrollViewDelegate<##>
    func numbersOfPages() -> Int {
        return picArray.count
    }
    
    func imageNameOfIndex(_ index: Int) -> String! {
        return picArray[index]
    }
    
    func didSelectedIndex(_ index: Int) {
        print("you click autoScrollView index:\(index)")
        self.delegate?.selectedPic("\(index)")
        
    }
    
    func currentIndexDidChange(_ index: Int) {
        print("autoScrollView currentIndex didChange :\(index)")
    }
    
    func indexDidChange(_ index: Int) {
        print("scrollView currentIndexDidChange :\(index)")
    }
}


