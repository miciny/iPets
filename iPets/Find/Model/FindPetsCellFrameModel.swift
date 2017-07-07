//
//  FindPetsCellFrameModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/30.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class FindPetsCellFrameModel: NSObject {

    var iconF = CGRect()
    var nameF = CGRect()
    var timeF = CGRect()
    var moreF = CGRect()
    var cellHeight = CGFloat()
    
    var textF: CGRect?
    var pictureF: [CGRect]?
    var deleteBtnF: CGRect?
    var videoF: CGRect?
    var myCellModel: FindPetsCellModel!
    
    let padding: CGFloat = 10
    
    func setCellModel(_ cellModel: FindPetsCellModel){
        myCellModel = cellModel
        
        self.icon()
        self.name()
        
        self.text()
        self.pics()
        self.video()
        
        self.time()
        self.delete()
        self.more()
        
        cellHeight = timeF.maxY + padding*2
    }
    
    //
    func icon(){
        let iconX: CGFloat = 10
        let iconY: CGFloat = 10
        let iconW: CGFloat = 40
        let iconH: CGFloat = 40
        iconF = CGRect(x: iconX, y: iconY, width: iconW, height: iconH)
    }
    
    //
    func name(){
        let nameSize = sizeWithText(myCellModel!.name, font: nameFont, maxSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        let nameX = iconF.maxX + padding
        let nameY = iconF.minY
        nameF = CGRect(x: nameX, y: nameY, width: nameSize.width, height: nameSize.height)
        timeF.origin.y = nameF.maxY + padding*3 //没有图片时的位置
    }
    
    //?
    func text(){
        if let text = myCellModel.text{
            let textX = nameF.minX
            let textY = nameF.maxY + padding/2
            let textSize = sizeWithText(text, font: textFont, maxSize: CGSize(width: Width-textX-10, height: CGFloat(MAXFLOAT)))
            textF = CGRect(x: textX, y: textY, width: textSize.width, height: textSize.height)
            timeF.origin.y = textF!.maxY + padding*3 //没有图片时的位置
        }
    }
    
    //?
    func video(){
        if let _ = myCellModel.video{
            let videoX = nameF.minX
            let videoY = nameF.maxY + padding/2
            let videoSize = CGSize(width: Width-videoX-20, height: 200)
            videoF = CGRect(x: videoX, y: videoY, width: videoSize.width, height: videoSize.height)
            
            timeF.origin.y = videoF!.maxY + padding
        }
    }
    
    //?
    func pics(){
        if let pic = myCellModel.picture{
            pictureF = [CGRect]()
            let picCount = pic.count
            let pictureX = nameF.minX
            let pictureY = (textF == nil ? nameF.maxY : textF!.maxY) + padding/2
            
            //一张图
            if picCount == 1{
                let saveCache = SaveCacheDataModel()
                let imageData = saveCache.loadImageFromFindPetsCacheDir(pic[0])
                let image = ChangeValue.dataToImage(imageData)
                let imageSize = image.size
                let pictureW = (imageSize.width > 170 ? 170 : imageSize.width)
                let pictureH = imageSize.height/(imageSize.width/170)
                
                pictureF!.append(CGRect(x: pictureX, y: pictureY, width: CGFloat(pictureW), height: CGFloat(pictureH)))
                
            }else{  //多张图
                let pictureW = (Width-nameF.minX*2)/3
                let pictureH = (Width-nameF.minX*2)/3
                let gap = CGFloat(5)
                
                if picCount == 4{ //四张图
                    for j in 0 ..< picCount {
                        pictureF!.append(CGRect(
                            x: pictureX + (pictureW + gap) * CGFloat(j%2),
                            y: pictureY + (pictureH + gap) * CGFloat(j/2),
                            width: pictureW,
                            height: pictureH
                        ))
                    }
                    
                }else{
                    for j in 0 ..< picCount {
                        pictureF!.append(CGRect(
                            x: pictureX + (pictureW + gap) * CGFloat(j%3),
                            y: pictureY + (pictureH + gap) * CGFloat(j/3),
                            width: pictureW,
                            height: pictureH
                        ))
                    }
                }
            }
            timeF.origin.y = pictureF!.last!.maxY + padding
        }
    }
    
    
    //
    func time(){
        
        let dateStr = DateToToString.getFindPetsTimeFormat(myCellModel!.date)
        let timeSize = sizeWithText(dateStr, font: timeFont, maxSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        let timeX = nameF.minX
        let timeY = timeF.origin.y
        timeF = CGRect(x: timeX, y: timeY, width: timeSize.width+4, height: timeSize.height)
    }
    
    //?
    func delete(){
        guard myCellModel.nickname == myInfo.nickname else {
            return
        }
        
        let deleteBtnX = timeF.maxX+padding
        let deleteBtnY = timeF.minY
        let deleteSize = sizeWithText("删除", font: timeFont, maxSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        deleteBtnF = CGRect(x: deleteBtnX, y: deleteBtnY, width: deleteSize.width, height: deleteSize.height)
    }
    
    //
    func more(){
        let deleteSize = sizeWithText("删除", font: timeFont, maxSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        let moreX = Width-25-10
        let moreY = timeF.minY-padding/2
        let moreSize = CGSize(width: 25, height: deleteSize.height + padding)
        
        moreF = CGRect(x: moreX, y: moreY, width: moreSize.width, height: moreSize.height)
    }
}
