//
//  VideoTableViewCell.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/21.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    var newsItem: NewsDataModule!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: NewsDataModule, reuseIdentifier cellId:String, indexPath: IndexPath){
        self.newsItem = data
        super.init(style: .default, reuseIdentifier: cellId)
        rebuildCell(indexPath)
    }
    
    
    func rebuildCell(_ indexPath: IndexPath){
        let category = newsItem.category!
        if category == .video {
            rebuild_VIDEO_Cell(indexPath)
        }
    }
    
    //=========================video==================================================
    func rebuild_VIDEO_Cell(_ indexPath: IndexPath){
        var videoOrigin = CGPoint(x: 10, y: 12)     //视频的起始位置
        
        //普通标题
        if let title = newsItem.title{
            let titleLBSizeT = sizeWithText("测试", font: newsTitleFont, maxSize: CGSize(width: Width-30, height: Height))
            let titleLBSize = sizeWithText(title, font: newsTitleFont, maxSize: CGSize(width: Width-30, height: titleLBSizeT.height))
            let titleLB = UILabel()
            titleLB.frame = CGRect(x: 10, y: 12, width: titleLBSize.width, height: titleLBSize.height)
            titleLB.font = newsTitleFont
            titleLB.lineBreakMode = NSLineBreakMode.byWordWrapping  //截去多余部分也不显示省略号
            titleLB.text = title
            self.addSubview(titleLB)
            
            //这是video的距离
            videoOrigin.x = titleLB.frame.minX
            videoOrigin.y = titleLB.frame.maxY+12
        }
        
        //视频,传入indexPath，滑出屏幕就停止,不传就不停
        if let video = newsItem.videoUrl{
            let avView = BaseVideoView()
            avView.setUp(CGRect(x: 0, y: videoOrigin.y, width: Width, height: newsItem.cellHeight-videoOrigin.y),
                         videoUrl: video,
                         picUrl: newsItem.videoPic!,
                         runtime: newsItem.videoRuntime,
                         indexPath: indexPath,
                         videoTitle: newsItem.title,
                         showCloseBtn: false)
            
            self.addSubview(avView)
        }
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
