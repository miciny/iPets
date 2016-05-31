//
//  Cache.swift
//  iPets
//
//  Created by maocaiyuan on 16/4/12.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class Cache: NSObject {
    
    static var cacheSize: String{
        get{
            let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
            let fileManager = NSFileManager.defaultManager()
            
            func caculateCache() -> Float{
                var total: Float = 0
                if fileManager.fileExistsAtPath(basePath!){
                    let childrenPath = fileManager.subpathsAtPath(basePath!)
                    if childrenPath != nil{
                        for path in childrenPath!{
                            let childPath = basePath!.stringByAppendingString("/").stringByAppendingString(path)
                            do{
                                let attr = try fileManager.attributesOfItemAtPath(childPath)
                                let fileSize = attr["NSFileSize"] as! Float
                                total += fileSize
                                
                            }catch _{
                                
                            }
                        }
                    }
                }
                return total
            }
            let totalCache = caculateCache()
            return NSString(format: "%.2fMB", totalCache / 1024.0 / 1024.0 ) as String
        }
    }
    
    // 清除缓存
    class func clearCache() -> Bool{
        var result = true
        let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(basePath!){
            let childrenPath = fileManager.subpathsAtPath(basePath!)
            for childPath in childrenPath!{
                let cachePath = basePath?.stringByAppendingString("/").stringByAppendingString(childPath)
                do{
                    try fileManager.removeItemAtPath(cachePath!)
                }catch _{
                    result = false
                }
            }
        }
        
        return result
    }
    
}
