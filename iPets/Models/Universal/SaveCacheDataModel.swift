//
//  SaveCacheDataModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/31.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SaveCacheDataModel: NSObject {
    
    // 获取沙盒缓存文件夹路径
    func getCacheDirectory() -> AnyObject{
        
        let cachePaths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let cachePath = cachePaths[0]
        return cachePath
    }

    //创建一个文件夹
    func createDirInCache(dirName: String) -> AnyObject{
        
        let cacheDir = getCacheDirectory()
        let findPetsDir = cacheDir.stringByAppendingPathComponent(dirName)
        let manager = NSFileManager.defaultManager()
        if !manager.fileExistsAtPath(findPetsDir) {
            do{
                try
                    manager.createDirectoryAtPath(findPetsDir, withIntermediateDirectories: true, attributes: nil)
            }catch let error as NSError{
                print("创建失败！")
                print(error)
            }
        }
        return findPetsDir
    }
    
    //删除一个文件夹
    func deleteDirInChatCache(dirName: String){
        
        let chatDirPath = createDirInCache(ChatImageDataSaveFolderName)  //获取本地数据文件地址
        let defaultManager = NSFileManager.defaultManager()   //声明文件管理器
        let singleChatDir = chatDirPath.stringByAppendingPathComponent(dirName)
        
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExistsAtPath(singleChatDir) {
            do{
                try
                    defaultManager.removeItemAtPath(singleChatDir)
                print("删除缓存文件夹成功！")
            }catch let error as NSError{
                print("删除缓存文件夹失败！")
                print(error)
            }
        }
    }
    
    //创建一个聊天的子文件夹，每个人都不同
    func createDirInChatCache(dirName: String) -> AnyObject{
        let chatDirPath = createDirInCache(ChatImageDataSaveFolderName)
        
        let singleChatDir = chatDirPath.stringByAppendingPathComponent(dirName)
        let manager = NSFileManager.defaultManager()
        if !manager.fileExistsAtPath(singleChatDir) {
            do{
                try
                    manager.createDirectoryAtPath(singleChatDir, withIntermediateDirectories: true, attributes: nil)
            }catch let error as NSError{
                print("创建失败！")
                print(error)
            }
        }
        return singleChatDir
    }
    
    //保存图片到chat目录
    func savaImageToChatCacheDir(dirName: String, image: UIImage, imageName: String, imageType: String) -> Bool {
        
        let chatDirPath = createDirInChatCache(dirName)
        
        let imageName = imageName
        var isSaved = Bool()
        let type = imageType.lowercaseString
        
        if (type == "png"){
            do{
                try
                    UIImagePNGRepresentation(image)?.writeToFile(chatDirPath.stringByAppendingPathComponent("\(imageName).png"), options: .AtomicWrite)
                isSaved = true
            }catch let error as NSError{
                print(error)
                isSaved = false
            }
            
        }else if(type == "jpg" || type == "jpeg")
        {
            do{
                try
                    UIImageJPEGRepresentation(image, 1.0)?.writeToFile(chatDirPath.stringByAppendingPathComponent("\(imageName).jpg"), options: .AtomicWrite)
                isSaved = true
            }catch let error as NSError{
                print(error)
                isSaved = false
            }
        }else{
            print("图片后缀不支持！")
        }
        print(chatDirPath.stringByAppendingPathComponent("\(imageName).png"))
        return isSaved
    }
    
    //保存图片到chat目录
    func savaImageToChatCacheDir(dirName: String, imageData: NSData, imageName: String) -> Bool {
        
        let chatDirPath = createDirInChatCache(dirName)
        
        let imageName = imageName
        var isSaved = Bool()
        
        do{
            try
                imageData.writeToFile(chatDirPath.stringByAppendingPathComponent(imageName), options: .AtomicWrite)
            isSaved = true
        }catch let error as NSError{
            print(error)
            isSaved = false
        }
        
//        print(chatDirPath.stringByAppendingPathComponent(imageName))
        return isSaved
    }
    
    
    // 从chat读取image
    func loadImageFromChatCacheDir(dirName: String, imageName: String) -> NSData {
        let imagePath = createDirInChatCache(dirName).stringByAppendingPathComponent(imageName)
        var imageData = NSData()
        if NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
            imageData = NSData(contentsOfFile: imagePath)!
        }
        return imageData
    }
    
    //保存图片到findPets目录
    func savaImageToFindPetsCacheDir(image: UIImage, imageName: String, imageType: String) -> Bool {
        let imagePath = createDirInCache(findPetsImageDataSaveFolderName)
        let imageName = imageName
        var isSaved = Bool()
        let type = imageType.lowercaseString
        
        if (type == "png"){
            do{
                try
                    UIImagePNGRepresentation(image)?.writeToFile(imagePath.stringByAppendingPathComponent("\(imageName).png"), options: .AtomicWrite)
                isSaved = true
            }catch let error as NSError{
                print(error)
                isSaved = false
            }
            
        }else if(type == "jpg" || type == "jpeg"){
            do{
                try
                    UIImageJPEGRepresentation(image, 1.0)?.writeToFile(imagePath.stringByAppendingPathComponent("\(imageName).jpg"), options: .AtomicWrite)
                isSaved = true
            }catch let error as NSError{
                print(error)
                isSaved = false
            }
        }else{
            print("图片后缀不支持！")
        }
//        print(imagePath.stringByAppendingPathComponent("\(imageName).png"))
        return isSaved
    }
    
    //保存图片到findPets目录
    func savaImageToFindPetsCacheDir(imageData: NSData, imageName: String) -> Bool {
        let imagePath = createDirInCache(findPetsImageDataSaveFolderName)
        let imageName = imageName
        var isSaved = Bool()
        
        do{
            try
            imageData.writeToFile(imagePath.stringByAppendingPathComponent(imageName), options: .AtomicWrite)
            isSaved = true
        }catch let error as NSError{
            print(error)
            isSaved = false
        }
        
//        print(imagePath.stringByAppendingPathComponent(imageName))
        return isSaved
    }
    
    
    // 从findpets读取image
    func loadImageFromFindPetsCacheDir(imageName: String) -> NSData {
        let imagePath = createDirInCache(findPetsImageDataSaveFolderName).stringByAppendingPathComponent(imageName)
        var imageData = NSData()
        if NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
            imageData = NSData(contentsOfFile: imagePath)!
//            print(imagePath)
        }
        return imageData
    }
    
    // 从findpets删除image
    func deleteImageFromFindPetsCacheDir(imageName: [String]){
        let manager = NSFileManager.defaultManager()
        for i in 0 ..<  imageName.count{
        
            let imagePath = createDirInCache(findPetsImageDataSaveFolderName).stringByAppendingPathComponent("H"+imageName[i])
//            print(imagePath)
            if manager.fileExistsAtPath(imagePath) {
                do{
                    try
                        manager.removeItemAtPath(imagePath)
                    print("删除高清图成功")
                }catch let error as NSError{
                    print("删除高清图失败！")
                    print(error)
                }
                
            }
            
            let imagePath1 = createDirInCache(findPetsImageDataSaveFolderName).stringByAppendingPathComponent(imageName[i])
            if manager.fileExistsAtPath(imagePath1) {
                do{
                    try
                        manager.removeItemAtPath(imagePath1)
                    print("删除普通图成功！")
                }catch let error as NSError{
                    print("删除普通图失败！")
                    print(error)
                }
                
            }
            
        
        }
    }
}