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

    private var picArray = ["defaultIcon"]
    var delegate: SellBuyHeaderDelegate?
    
    // 主页的头图
    func addHeaderScrollPicsView(pic: NSArray){
        picArray = pic as! [String]
        
        let autoScrollView = HeaderCycleView(frame: CGRectMake(0, 0, Width, Width*0.5))
        autoScrollView.backgroundColor = UIColor.grayColor()
        autoScrollView.delegate = self
        autoScrollView.autoScroll = true
        self.addSubview(autoScrollView)
    }
    
    // 主页的其它头图
    func addHeaderTitleView(title: String){
        let view = UIView(frame: CGRectMake(0, 0, Width, 30))
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        let lable = UILabel(frame: view.frame)
        lable.backgroundColor = UIColor.clearColor()
        lable.textAlignment = .Center
        lable.font = UIFont.systemFontOfSize(22)
        lable.text = title
        view.addSubview(lable)
        
        self.addSubview(view)
    }
    
    //MARK:- MCYAutoScrollViewDelegate<##>
    func numbersOfPages() -> Int {
        return picArray.count
    }
    
    func imageNameOfIndex(index: Int) -> String! {
        return picArray[index]
    }
    
    func didSelectedIndex(index: Int) {
        print("you click autoScrollView index:\(index)")
        
        self.delegate?.selectedPic("\(index)")
        
    }
    
    func currentIndexDidChange(index: Int) {
        print("autoScrollView currentIndex didChange :\(index)")
    }
    
    func indexDidChange(index: Int) {
        print("scrollView currentIndexDidChange :\(index)")
    }
}


