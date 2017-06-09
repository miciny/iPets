//
//  JsonCache.swift
//  MyNews
//
//  Created by maocaiyuan on 16/6/18.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit
import SwiftyJSON

//缓存json数据到本地的目录和名字
let tempJsonDir = "TempJsonDir"

class JsonCache: NSObject {
    
    // 获取沙盒缓存文件夹路径
    class func getCacheDirectory() -> AnyObject{
        let cachePaths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachePath = cachePaths[0]
        return cachePath as AnyObject
    }
    
    //创建一个文件夹
    class func getDirInCache(_ dirName: String) -> AnyObject{
        
        let cacheDir = getCacheDirectory()
        let findPetsDir = cacheDir.strings(byAppendingPaths: [dirName])[0]
        let manager = FileManager.default
        
        if !manager.fileExists(atPath: findPetsDir) {
            do{
                try
                    manager.createDirectory(atPath: findPetsDir, withIntermediateDirectories: true, attributes: nil)
            }catch let error as NSError{
                print("创建失败！")
                print(error)
            }
        }
        return findPetsDir as AnyObject
    }
    
    //保存json到tempJsonDir目录
    class func savaJsonToCacheDir(_ json: JSON, name: String) -> Bool {
        let dirPath = getDirInCache(tempJsonDir)
        var isSaved = Bool()
        
        do{
            let path = dirPath.strings(byAppendingPaths: [name + ".json"])[0]
            let str = try json["data"].rawData()
            
            do {
                try str.write(to: URL(fileURLWithPath: path), options: .atomic)
                isSaved = true
            }catch let error as NSError{
                print(error)
                isSaved = false
            }
            
        }catch let error as NSError{
            print(error)
            isSaved = false
        }
        
        return isSaved
    }

    
    // 从cache读取json
    class func loadjsonFromCacheDir(_ jsonName: String) -> JSON?{
        let jsonPath = getDirInCache(tempJsonDir).strings(byAppendingPaths: [jsonName+".json"])[0]
        var json: JSON?
        
        if FileManager.default.fileExists(atPath: jsonPath) {
            do {
                let nsdata = try Data(contentsOf: URL(fileURLWithPath: jsonPath))
                try json = JSON(data: nsdata)
            }catch let error as NSError{
                print(error)
            }
        }else{
            json = nil
        }
        return json
    }
}
