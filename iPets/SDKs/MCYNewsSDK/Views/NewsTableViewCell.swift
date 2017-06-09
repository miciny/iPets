//
//  NewsTableViewCell.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/18.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

class NewsTableViewCell: UITableViewCell {
    
    var newsItem: NewsDataModule!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(data: NewsDataModule, reuseIdentifier cellId:String, indexPath: IndexPath){
        self.newsItem = data
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        rebuildCell(indexPath)
    }
    
    func rebuildCell(_ indexPath: IndexPath){
        let category = newsItem.category!
        switch category {
        case .cms:
            rebuild_Common_Cell(indexPath)
        case .url:
            rebuild_Common_Cell(indexPath)
        case .blog:
            rebuild_Common_Cell(indexPath)
        case .original:
            rebuild_Common_Cell(indexPath)
        case .live:
            rebuild_Common_Cell(indexPath)
        case .zhuanlan:
            rebuild_Common_Cell(indexPath)
        case .plan:
            rebuild_Common_Cell(indexPath)
        case .subject:
            rebuild_Common_Cell(indexPath)
        case .hdpic:
            rebuild_HDPIC_Cell()
        case .mp:
            rebuild_Common_Cell(indexPath)
        case .consice:
            rebuild_Common_Cell(indexPath)
        case .video:
            rebuild_VIDEO_Cell(indexPath)
        case .unkown:
            break
        }
    }

//=========================video==================================================
    func rebuild_VIDEO_Cell(_ indexPath: IndexPath){
        //检查是不是显示视频，还是显示视频标签
        guard newsItem.videoUrl != nil else{
            rebuild_Common_Cell(indexPath)
            return
        }
        
        var videoOrigin = CGPoint(x: 10, y: 8)     //视频的起始位置
        var labelOrigin = CGPoint(x: 10, y: 8)     //标签的起始位置
        
        //普通标题
        if let title = newsItem.title{
            let titleLBSize = sizeWithText("测试", font: newsTitleFont, maxSize: CGSize(width: Width-20, height: Height))
            let titleLB = UILabel()
            titleLB.lineBreakMode = NSLineBreakMode.byWordWrapping  //截去多余部分也不显示省略号
            titleLB.frame = CGRect(x: 10, y: 8, width: Width-20, height: titleLBSize.height)
            titleLB.font = newsTitleFont
            titleLB.text = title
            self.addSubview(titleLB)
            
            //这是video的距离
            videoOrigin.x = titleLB.frame.minX
            videoOrigin.y = titleLB.frame.maxY+5
        }
        
        //视频,传入indexPath，滑出屏幕就停止,不传就不停
        if let video = newsItem.videoUrl{
            let avView = BaseVideoView()
            avView.setUp(CGRect(x: videoOrigin.x, y: videoOrigin.y, width: Width-20, height: newsItem.cellHeight-videoOrigin.y-30),
                         videoUrl: video,
                         picUrl: newsItem.videoPic!,
                         runtime: newsItem.videoRuntime,
                         indexPath: indexPath,
                         videoTitle: newsItem.title,
                         showCloseBtn: false
            )
            self.addSubview(avView)
            labelOrigin.y = newsItem.cellHeight-20
        }
        
        //标签
        let label = UILabel.labelLabel("视频", textColor: UIColor.blue)
        label.frame.origin = CGPoint(x: Width-label.width-10, y: labelOrigin.y)
        self.addSubview(label)
        
        //评论数
        if let comment = newsItem.comment{
            let commentStr = String(comment)
            let commentLB = UILabel.commentLabel(commentStr)
            commentLB.frame.origin = CGPoint(x: Width-20-commentLB.width-label.width, y: labelOrigin.y)
            self.addSubview(commentLB)
        }

    }

//=========================hdpic==================================================
    func rebuild_HDPIC_Cell(){
        var picsOrigin = CGPoint(x: 10, y: 8)     //图片的起始位置
        var labelOrigin = CGPoint(x: 10, y: 8)     //标签的起始位置
        
        //普通标题
        if let title = newsItem.title{
            let titleLBSize = sizeWithText("测试", font: newsTitleFont, maxSize: CGSize(width: Width-20, height: Height))
            let titleLB = UILabel()
            titleLB.lineBreakMode = NSLineBreakMode.byWordWrapping  //截去多余部分也不显示省略号
            titleLB.frame = CGRect(x: 10, y: 8, width: Width-20, height: titleLBSize.height)
            titleLB.font = newsTitleFont
            titleLB.text = title
            self.addSubview(titleLB)
            
            //这是intro的距离
            picsOrigin.x = titleLB.frame.minX
            picsOrigin.y = titleLB.frame.maxY
        }
        
        //图片
        let picGap = CGFloat(5)
        let picW = (Width-20-picGap*2)/3
        let picH = newsItem.cellHeight-picsOrigin.y-5-30
        if let pics = newsItem.list{
            let count = pics.count>3 ? 3 : pics.count
            for i in 0 ..< count {
                let list = pics[i]
                let pic = list["pic"].stringValue
                
                let picView = UIImageView.cellPicView()
                picView.frame = CGRect(x: picsOrigin.x+(picGap+picW)*CGFloat(i), y: picsOrigin.y+5, width: picW, height: picH)
                NetFuncs.showPic(imageView: picView, picUrl: pic)
                self.addSubview(picView)
                
                //这是label的距离
                labelOrigin.y = picView.frame.maxY+10
            }
        }
        
        //标签
        let label = UILabel.labelLabel("图集", textColor: UIColor.red)
        label.frame.origin = CGPoint(x: Width-label.frame.width-10, y: labelOrigin.y)
        self.addSubview(label)
        
        //评论数
        if let comment = newsItem.comment{
            let commentStr = String(comment)
            let commentLB = UILabel.commentLabel(commentStr)
            commentLB.frame.origin = CGPoint(x: Width-20-commentLB.frame.width-label.frame.width, y: label.frame.minY)
            self.addSubview(commentLB)
        }
    }
    
    
//=========================cms/url/blog/original ／／ video // live==================================================
    func rebuild_Common_Cell(_ indexPath: IndexPath){
        
        //检查是不是显示视频，还是显示视频标签
        guard newsItem.videoUrl == nil else{
            rebuild_VIDEO_Cell(indexPath)
            return
        }
        
        var titleOrigin = CGPoint(x: 10, y: 8)     //title的起始位置
        var introOrigin = CGPoint(x: 10, y: 15)     //简介的起始位置
        var commentX = Width    //起始位置,如果想不显示，这只为－1，如直播
        
        //普通新闻左侧图片
        if newsItem.feedShowStyle == feedShowStyleType.common{
            if let kpic = newsItem.kpic{
                let newsIcon = UIImageView.cellPicView()
                newsIcon.frame = CGRect(x: 10, y: 10, width: newsItem.cellHeight+5, height: newsItem.cellHeight-20)
                NetFuncs.showPic(imageView: newsIcon, picUrl: kpic)
                self.addSubview(newsIcon)
                
                //这是title的距离
                titleOrigin.x = newsIcon.maxXX
                titleOrigin.y = newsIcon.y
            }
        }
        
        //普通标题
        if let title = newsItem.title{
            let titleLBSize = sizeWithText("测试", font: newsTitleFont, maxSize: CGSize(width: Width-titleOrigin.x-20, height: Height))
            let titleLB = UILabel()
            titleLB.lineBreakMode = NSLineBreakMode.byWordWrapping  //截去多余部分也不显示省略号
            titleLB.frame = CGRect(x: titleOrigin.x+5, y: titleOrigin.y, width: Width-titleOrigin.x-20, height: titleLBSize.height)
            titleLB.font = newsTitleFont
            titleLB.text = title
            self.addSubview(titleLB)
            
            //这是intro的距离
            introOrigin.x = titleLB.x
            introOrigin.y = titleLB.maxYY + 5
        }
        
        //普通简介
        if newsItem.feedShowStyle == feedShowStyleType.common{
            if let intro = newsItem.intro{
                let introLBSize = sizeWithText(intro, font: newsIntroFont, maxSize: CGSize(width: Width-introOrigin.x-20, height: Height))
                let introLB = UILabel()
                introLB.frame = CGRect(x: introOrigin.x, y: introOrigin.y, width: Width-introOrigin.x-20, height: introLBSize.height)
                introLB.font = newsIntroFont
                introLB.textColor = UIColor.lightGray
                introLB.numberOfLines = 0
                introLB.text = intro
                self.addSubview(introLB)
            }
        }else if newsItem.feedShowStyle == feedShowStyleType.bigImage{  //大图模式
            if let kpic = newsItem.kpic{
                let picView = UIImageView.cellPicView()
                picView.frame = CGRect(x: 10, y: introOrigin.y, width: Width-20, height: newsItem.cellHeight-introOrigin.y-30)
                
                NetFuncs.showPic(imageView: picView, picUrl: kpic)
                self.addSubview(picView)
            }
        }
        
        if newsItem.category == newsType.video {
            //标签
            let label = UILabel.labelLabel("视频", textColor: UIColor.blue)
            label.frame.origin = CGPoint(x: Width-label.frame.width-10, y: newsItem.cellHeight-8-label.frame.height)
            self.addSubview(label)
            
            commentX = label.frame.minX
        }else if newsItem.category == newsType.live{
            //标签
            let label = UILabel.labelLabel("直播", textColor: UIColor.red)
            label.frame.origin = CGPoint(x: Width-label.frame.width-10, y: newsItem.cellHeight-8-label.frame.height)
            self.addSubview(label)
            
            commentX = -1
        }else if newsItem.category == newsType.subject{
            //标签
            let label = UILabel.labelLabel("专题", textColor: UIColor.red)
            label.frame.origin = CGPoint(x: Width-label.frame.width-10, y: newsItem.cellHeight-8-label.frame.height)
            self.addSubview(label)
            
            commentX = label.frame.minX
        }else if newsItem.category == newsType.plan{
            //标签
            let label = UILabel.labelLabel("策划", textColor: UIColor.red)
            label.frame.origin = CGPoint(x: Width-label.frame.width-10, y: newsItem.cellHeight-8-label.frame.height)
            self.addSubview(label)
            
            commentX = label.frame.minX
        }else if newsItem.category == newsType.consice{
            //标签
            let label = UILabel.labelLabel("精读", textColor: UIColor.red)
            label.frame.origin = CGPoint(x: Width-label.frame.width-10, y: newsItem.cellHeight-8-label.frame.height)
            self.addSubview(label)
            
            commentX = label.frame.minX
        }
        
        //评论数
        if let comment = newsItem.comment{
            if commentX != -1 {
                let commentStr = DataFormat.commentFormat(comment)
                let commentLB = UILabel.commentLabel(commentStr)
                commentLB.frame.origin = CGPoint(x: commentX-10-commentLB.frame.width, y: newsItem.cellHeight-8-commentLB.frame.height)
                self.addSubview(commentLB)
            }
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
