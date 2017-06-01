//
//  ImageChooseFuncs.swift
//  iPets
//
//  Created by maocaiyuan on 2017/5/25.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import Foundation
import Photos


//缩略图
func getThumbnailImage(asset: PHAsset, imageResult: @escaping (_ image: UIImage)->()){
    
    let options = PHImageRequestOptions.init()
    options.isSynchronous = true
    
    //根据单元格的尺寸计算我们需要的缩略图大小
    let assetGridThumbnailSize = CGSize(width: (Width)/3, height: (Width)/3)
    
    PHCachingImageManager.default().requestImage(for: asset,
                                                 targetSize: assetGridThumbnailSize,
                                                 contentMode: PHImageContentMode.aspectFit,
                                                 options: options) { (image, nfo) in
        imageResult(image!)
    }
}

//大一点的缩略图
func getBigThumbnailImage(asset: PHAsset, imageResult: @escaping (_ image: UIImage)->()){
    
    let options = PHImageRequestOptions.init()
    options.isSynchronous = true
    
    //根据单元格的尺寸计算我们需要的缩略图大小
    let assetGridThumbnailSize = CGSize(width: (Width)/2, height: (Width)/2)
    
    PHCachingImageManager.default().requestImage(for: asset,
                                                 targetSize: assetGridThumbnailSize,
                                                 contentMode: PHImageContentMode.aspectFit,
                                                 options: options) { (image, nfo) in
                                                    imageResult(image!)
    }
}

func getRetainImage(asset: PHAsset, imageResult: @escaping (_ image: UIImage)->()){
    
    let options = PHImageRequestOptions.init()
    options.isSynchronous = true
    
    PHImageManager.default().requestImage(for: asset,
                                          targetSize: PHImageManagerMaximumSize,
                                          contentMode: .default,
                                          options: options,
                                          resultHandler: { (image, _) in
       imageResult(image!)
    })
}
