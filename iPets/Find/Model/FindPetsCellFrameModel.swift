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
    
    func setCellModel(_ cellModel: FindPetsCellModel){
        myCellModel = cellModel
        let padding : CGFloat = 10
        
        //icon
        let iconX = padding
        let iconY = padding
        let iconW : CGFloat = 40
        let iconH : CGFloat = 40
        iconF = CGRect(x: iconX, y: iconY, width: iconW, height: iconH)
        
        //name
        var nameSize = CGSize()
        if myCellModel!.nickname == myInfo.nickname! && myCellModel?.name != myInfo.username{
            nameSize = sizeWithText(myInfo.username! as NSString, font: nameFont, maxSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        }else{
            nameSize = sizeWithText(myCellModel!.name as NSString, font: nameFont, maxSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        }
        let nameX = iconF.maxX + padding
        let nameY = iconY
        nameF = CGRect(x: nameX, y: nameY, width: nameSize.width, height: nameSize.height)
        
        // text
        let textX = nameX
        let textY = nameF.maxY + padding/2
        let textSize = sizeWithText(myCellModel!.text as NSString, font: textFont, maxSize: CGSize(width: Width-textX-10, height: CGFloat(MAXFLOAT)))
        textF = CGRect(x: textX, y: textY, width: textSize.width, height: textSize.height)
        
        //hide
        let hideSize = sizeWithText("全文", font: hideFont, maxSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        let hideX = nameX
        let hideY = textF.maxY + padding
        hideBtnF = CGRect(x: hideX, y: hideY, width: hideSize.width, height: hideSize.height)
        
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
                let pictureY = (myCellModel!.text == "" ? nameF : textF).maxY + padding
                let pictureW = (imageSize.width > 170 ? 170 : imageSize.width)
                let pictureH = imageSize.height/(imageSize.width/170)
                pictureF.append(CGRect(x: pictureX, y: pictureY, width: CGFloat(pictureW), height: CGFloat(pictureH)))
                timeY = pictureF[0].maxY + padding
            }else{  //多张图
                let pictureW = (Width-nameX*2)/3
                let pictureH = (Width-nameX*2)/3
                let pictureX = nameX
                let pictureY = (myCellModel!.text == "" ? nameF : textF).maxY + padding
                let gap = CGFloat(5)
                if picCount == 4{ //四张图
                    for j in 0 ..< picCount {
                        pictureF.append(CGRect(
                            x: pictureX + (pictureW + gap) * CGFloat(j%2),
                            y: pictureY + (pictureH + gap) * CGFloat(j/2),
                            width: pictureW,
                            height: pictureH
                            ))
                        timeY = pictureF[j].maxY + padding
                    }
                }else{
                    for j in 0 ..< picCount {
                        pictureF.append(CGRect(
                            x: pictureX + (pictureW + gap) * CGFloat(j%3),
                            y: pictureY + (pictureH + gap) * CGFloat(j/3),
                            width: pictureW,
                            height: pictureH
                            ))
                        timeY = pictureF[j].maxY + padding
                    }
                }
            }
            
        }else{
            timeY = textF.maxY + padding*3 //没有图片时的位置
        }
        
        //time
        let dateStr = DateToToString.getFindPetsTimeFormat(myCellModel!.date)
        let timeSize = sizeWithText(dateStr as NSString, font: timeFont, maxSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        let timeX = nameX
        timeF = CGRect(x: timeX, y: timeY, width: timeSize.width, height: timeSize.height)
        
        //deleteF
        let deleteBtnX = timeF.maxX+padding
        let deleteBtnY = timeY
        let deleteSize = sizeWithText("删除", font: timeFont, maxSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        deleteBtnF = CGRect(x: deleteBtnX, y: deleteBtnY, width: deleteSize.width, height: deleteSize.height)
        
        
        //more
        let moreX = Width-25-10
        let moreY = timeY-padding/2
        let moreSize = CGSize(width: 25, height: deleteSize.height+padding)
        moreF = CGRect(x: moreX, y: moreY, width: moreSize.width, height: moreSize.height)
        
        cellHeight = timeF.maxY + padding*2
    }
    

}
