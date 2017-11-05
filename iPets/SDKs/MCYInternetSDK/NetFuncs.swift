//
//  NetFuncs.swift
//  iPets
//
//  Created by maocaiyuan on 2017/6/8.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

//=====================================================================================================
/**
 
 从网络下载数据 必须使用https
 在Info.plist中添加NSAppTransportSecurity类型Dictionary。
 在NSAppTransportSecurity下添加NSAllowsArbitraryLoads类型Boolean,值设为YES
 
 **/
//=====================================================================================================


import UIKit
import Alamofire
import Kingfisher
import Reachability

//判断网络
enum networkType{
    case cell
    case wifi
    case nonet
}

class NetFuncs: NSObject {
    
    //========================================系统栏的转圈动画
    class func showNetIndicator(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    class func hidenNetIndicator(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    //========================================获得网络请求的manage
    
    class func getDefaultAlamofireManager() -> SessionManager{
        logger.info("初始化netmanager")
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5 //超时时间
        let netManager = Alamofire.SessionManager(configuration: configuration)
        return netManager
    }
    
    
    //========================================判断网络状况
    class func checkNet() -> networkType{
        let reachability = Reachability()!
        
        //判断连接类型
        if reachability.connection == .wifi {
            return networkType.wifi
        }else if reachability.connection == .cellular {
            return networkType.cell
        }else {
            return networkType.nonet
        }
    }
    
    
    //========================================图片的获取
    //从本地获取图片，不从网获取
    class func tryToRetrieveImageFromCacheForKeyNoNet(
        key: String,
        withURL URL: URL,
        progressBlock: DownloadProgressBlock?,
        completionHandler: CompletionHandler?,
        options: KingfisherOptionsInfo?,
        imageView: UIImageView){
        let diskTaskCompletionHandler: CompletionHandler = { (image, error, cacheType, imageURL) -> () in
            completionHandler?(image, error, cacheType, imageURL)
        }
        
        let imageCache = KingfisherManager.shared.cache
        imageCache.retrieveImage(
            forKey: key,
            options: options,
            completionHandler: { image, cacheType in
                if image != nil{
                    diskTaskCompletionHandler(image, nil, cacheType, URL as URL)
                    imageView.image = image
                }else{
                    diskTaskCompletionHandler(image, nil, .none, URL as URL)
                }
        })
    }
    
    
    //仅Wi-Fi下图,普通的
    class func addImageWiFiOnly(imageView: UIImageView, url: String, progressBlock: DownloadProgressBlock?, completionHandler: CompletionHandler?){
        
        //检查网络
        var wifi = true
        if checkNet() != networkType.wifi {
            wifi = false
        }
        
        //配置缓存
        let imageCache = KingfisherManager.shared.cache
        imageCache.maxDiskCacheSize = 150 * 1024 * 1024 //150M
        imageCache.maxCachePeriodInSecond = 60 * 60 * 24 * 1 //五天
        
        let options : KingfisherOptionsInfo = [.transition(ImageTransition.fade(0.3)),
                                               .targetCache(imageCache)
        ]
        
        //Wi-Fi下，下载缓存图片
        if wifi {
            imageView.kf.setImage(
                with: URL(string: url)!,
                placeholder: nil,
                options: options,
                progressBlock: progressBlock,
                completionHandler: completionHandler
            )
        }else{
            tryToRetrieveImageFromCacheForKeyNoNet(
                key: url,
                withURL: URL(string: url)!,
                progressBlock: progressBlock,
                completionHandler: completionHandler,
                options: options,
                imageView: imageView
            )
        }
    }
    
    //加载图片，有回调包的,不需要高度, 用在图片浏览上
    class func loadPic(imageView: UIImageView, picUrl: String, complete: @escaping (_ image: UIImage?)->()){
        //回调//设置图片, 进度条和动画
        let loading = LoadingPicView()
        loading.setView(imageView)
        
        addImageWiFiOnly(
            imageView: imageView,
            url: picUrl,
            progressBlock: { (receivedSize, totalSize) in
                //进度条
                loading.show()
                let value = Float(receivedSize)/Float(totalSize)
                loading.setValue(value)
        },
            completionHandler: { (image, error, cacheType, imageURL) in
                //停止动画 和 进度条
                loading.hide()
                
                complete(image)
                
                if image == nil{
                    imageView.backgroundColor = UIColor.cellPicBackColor() // 如果没有下载下来图片，就是变颜色
                }
                
        })
        
    }
    
    //用于cell中显示图片
    class func showPic(imageView: UIImageView, picUrl: String){
        addImageWiFiOnly(
            imageView: imageView,
            url: picUrl,
            progressBlock: nil,
            completionHandler: nil
        )
    }
}
