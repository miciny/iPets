//
//  SearchTableViewCell.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/15.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    var searchRecode: SearchRecordModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(data: SearchRecordModel, reuseIdentifier cellId:String){
        self.searchRecode = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildCell()
    }
    
    func rebuildCell(){
        if(searchRecode.type == 0){
            //搜索记录
            let searchRecodeSize = sizeWithText(searchRecode.record!, font: recordTitleFont, maxSize: CGSize(width: Width/2, height: 1000))
            let searchRecodeLabel = UILabel(frame: CGRect(x: 10, y: self.frame.origin.y,
                width: searchRecodeSize.width, height: self.frame.height))
            searchRecodeLabel.backgroundColor = UIColor.white
            searchRecodeLabel.textColor = UIColor.lightGray
            searchRecodeLabel.font = recordTitleFont
            searchRecodeLabel.textAlignment = .left
            searchRecodeLabel.text = searchRecode.record!
            self.addSubview(searchRecodeLabel)
            
        }else if(searchRecode.type == 1){
            //搜索记录
            let searchRecodeSize = sizeWithText(searchRecode.record!, font: contectorListPageLableFont, maxSize: CGSize(width: Width/2, height: 1000))
            let searchRecodeLabel = UILabel(frame: CGRect(x: 20, y: self.frame.origin.y,
                width: searchRecodeSize.width, height: self.frame.height))
            searchRecodeLabel.backgroundColor = UIColor.white
            searchRecodeLabel.font = contectorListPageLableFont
            searchRecodeLabel.textAlignment = .left
            searchRecodeLabel.text = searchRecode.record!
            self.addSubview(searchRecodeLabel)
            
        }else if(searchRecode.type == 2){
            let searchRecodeSize = sizeWithText(searchRecode.record!, font: contectorListPageLableFont, maxSize: CGSize(width: Width/2, height: 1000))
            let searchRecodeLabel = UILabel(frame: CGRect(x: Width/2-searchRecodeSize.width/2, y: self.frame.origin.y,
                width: searchRecodeSize.width, height: self.frame.height))
            searchRecodeLabel.backgroundColor = UIColor.white
            searchRecodeLabel.font = contectorListPageLableFont
            searchRecodeLabel.textAlignment = .center
            searchRecodeLabel.text = searchRecode.record!
            self.addSubview(searchRecodeLabel)
        }
        
    }

}
