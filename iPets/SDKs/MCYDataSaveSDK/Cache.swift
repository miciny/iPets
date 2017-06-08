//
//  Cache.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/7.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class Cache: NSObject {
    
    static var cacheSize: Float{
        get{
            let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let fileManager = FileManager.default
            
            func caculateCache() -> Float{
                var total: Float = 0
                if fileManager.fileExists(atPath: basePath!){
                    let childrenPath = fileManager.subpaths(atPath: basePath!)
                    if childrenPath != nil{
                        for path in childrenPath!{
                            let childPath = basePath!.appendingFormat("/").appendingFormat(path)
                            do{
                                let attr = try fileManager.attributesOfItem(atPath: childPath)
                                let fileSize = attr[FileAttributeKey.size] as! Float
                                total += fileSize
                                
                            }catch  let errer as NSError{
                                print("获取缓存失败")
                                print(errer)
                            }
                        }
                    }
                }
                return total
            }
            let totalCache = caculateCache()
            return (totalCache / 1024.0 / 1024.0)
        }
    }
    
    // 清除缓存
    class func clearCache() -> Bool{
        var result = true
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: basePath!){
            let childrenPath = fileManager.subpaths(atPath: basePath!)
            for childPath in childrenPath!{
                let cachePath = basePath!.appendingFormat("/").appendingFormat(childPath)
                if !cachePath.contains("/Caches/Snapshots") && fileManager.fileExists(atPath: cachePath){   //Snapshots 没有权限
                    do{
                        try fileManager.removeItem(atPath: cachePath)
                    }catch let errer as NSError{
                        print("清除缓存失败")
                        print(errer)
                        result = false
                    }
                }
            }
        }
        return result
    }
}
