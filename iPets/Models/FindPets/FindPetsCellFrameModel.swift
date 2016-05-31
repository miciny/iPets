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
    var textF = CGRect()
    var timeF = CGRect()
    var moreF = CGRect()
    var pictureF = [CGRect]()
    var deleteBtnF = CGRect()
    var hideBtnF = CGRect()
    
    var cellHeight = CGFloat()
    var myCellModel : FindPetsCellModel?
    
    func setCellModel(cellModel: FindPetsCellModel){
        myCellModel = cellModel
        let padding : CGFloat = 10
        
        //icon
        let iconX = padding
        let iconY = padding
        let iconW : CGFloat = 40
        let iconH : CGFloat = 40
        iconF = CGRectMake(iconX, iconY, iconW, iconH)
        
        //name
        var nameSize = CGSize()
        if myCellModel!.nickname == myInfo.nickname! && myCellModel?.name != myInfo.username{
            nameSize = sizeWithText(myInfo.username!, font: nameFont, maxSize: CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)))
        }else{
            nameSize = sizeWithText(myCellModel!.name, font: nameFont, maxSize: CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)))
        }
        let nameX = CGRectGetMaxX(iconF) + padding
        let nameY = iconY
        nameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height)
        
        // text
        let textX = nameX
        let textY = CGRectGetMaxY(nameF) + padding/2
        let textSize = sizeWithText(myCellModel!.text, font: textFont, maxSize: CGSizeMake(Width-textX-10, CGFloat(MAXFLOAT)))
        textF = CGRectMake(textX, textY, textSize.width, textSize.height)
        
        //hide
        let hideSize = sizeWithText("全文", font: hideFont, maxSize: CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)))
        let hideX = nameX
        let hideY = textF.maxY + padding
        hideBtnF = CGRectMake(hideX, hideY, hideSize.width, hideSize.height)
        
        var timeY = textY
        
        //picture
        if (myCellModel!.picture != nil) {
            let picCount = (myCellModel?.picture?.count)! as Int
            //一张图
            if picCount == 1{
                let saveCache = SaveCacheDataModel()
                let imageData = saveCache.loadImageFromFindPetsCacheDir(myCellModel!.picture![0])
                let image = ChangeValue.dataToImage(imageData)
                let imageSize = image.size
                
                let pictureX = nameX
                let pictureY = CGRectGetMaxY(myCellModel!.text == "" ? nameF : textF) + padding
                let pictureW = (imageSize.width > 170 ? 170 : imageSize.width)
                let pictureH = imageSize.height/(imageSize.width/170)
                pictureF.append(CGRectMake(pictureX, pictureY, CGFloat(pictureW), CGFloat(pictureH)))
                timeY = CGRectGetMaxY(pictureF[0]) + padding
            }else{  //多张图
                let pictureW = (Width-nameX*2)/3
                let pictureH = (Width-nameX*2)/3
                let pictureX = nameX
                let pictureY = CGRectGetMaxY(myCellModel!.text == "" ? nameF : textF) + padding
                let gap = CGFloat(5)
                if picCount == 4{ //四张图
                    for j in 0 ..< picCount {
                        pictureF.append(CGRectMake(
                            pictureX + (pictureW + gap) * CGFloat(j%2),
                            pictureY + (pictureH + gap) * CGFloat(j/2),
                            pictureW,
                            pictureH
                            ))
                        timeY = CGRectGetMaxY(pictureF[j]) + padding
                    }
                }else{
                    for j in 0 ..< picCount {
                        pictureF.append(CGRectMake(
                            pictureX + (pictureW + gap) * CGFloat(j%3),
                            pictureY + (pictureH + gap) * CGFloat(j/3),
                            pictureW,
                            pictureH
                            ))
                        timeY = CGRectGetMaxY(pictureF[j]) + padding
                    }
                }
            }
            
        }else{
            timeY = CGRectGetMaxY(textF) + padding*3 //没有图片时的位置
        }
        
        //time
        let dateStr = DateToToString.getFindPetsTimeFormat(myCellModel!.date)
        let timeSize = sizeWithText(dateStr, font: timeFont, maxSize: CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)))
        let timeX = nameX
        timeF = CGRectMake(timeX, timeY, timeSize.width, timeSize.height)
        
        //deleteF
        let deleteBtnX = CGRectGetMaxX(timeF)+padding
        let deleteBtnY = timeY
        let deleteSize = sizeWithText("删除", font: timeFont, maxSize: CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)))
        deleteBtnF = CGRectMake(deleteBtnX, deleteBtnY, deleteSize.width, deleteSize.height)
        
        
        //more
        let moreX = Width-25-10
        let moreY = timeY-padding/2
        let moreSize = CGSize(width: 25, height: deleteSize.height+padding)
        moreF = CGRectMake(moreX, moreY, moreSize.width, moreSize.height)
        
        cellHeight = CGRectGetMaxY(timeF) + padding*2
    }
    

}
