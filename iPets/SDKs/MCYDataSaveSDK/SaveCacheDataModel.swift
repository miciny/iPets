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
        
        let cachePaths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachePath = cachePaths[0]
        return cachePath as AnyObject
    }

    //创建一个文件夹
    func createDirInCache(_ dirName: String) -> AnyObject{
        
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
    
    //删除一个文件夹
    func deleteDirInChatCache(_ dirName: String){
        
        let chatDirPath = createDirInCache(ChatImageDataSaveFolderName)  //获取本地数据文件地址
        let defaultManager = FileManager.default   //声明文件管理器
        let singleChatDir = chatDirPath.strings(byAppendingPaths: [dirName])[0]
        
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExists(atPath: singleChatDir) {
            do{
                try
                    defaultManager.removeItem(atPath: singleChatDir)
                print("删除缓存文件夹成功！")
            }catch let error as NSError{
                print("删除缓存文件夹失败！")
                print(error)
            }
        }
    }
    
    //创建一个聊天的子文件夹，每个人都不同
    func createDirInChatCache(_ dirName: String) -> AnyObject{
        let chatDirPath = createDirInCache(ChatImageDataSaveFolderName)
        
        let singleChatDir = chatDirPath.strings(byAppendingPaths: [dirName])[0]
        let manager = FileManager.default
        if !manager.fileExists(atPath: singleChatDir) {
            do{
                try
                    manager.createDirectory(atPath: singleChatDir, withIntermediateDirectories: true, attributes: nil)
            }catch let error as NSError{
                print("创建失败！")
                print(error)
            }
        }
        return singleChatDir as AnyObject
    }
    
    //保存图片到chat目录
    func savaImageToChatCacheDir(_ dirName: String, image: UIImage, imageName: String, imageType: String) -> Bool {
        
        let chatDirPath = createDirInChatCache(dirName)
        
        let imageName = imageName
        var isSaved = Bool()
        let type = imageType.lowercased()
        
        if (type == "png"){
            do{
                try
                    UIImagePNGRepresentation(image)?.write(to: URL(fileURLWithPath: chatDirPath.appendingPathComponent("\(imageName).png")), options: .atomicWrite)
                isSaved = true
            }catch let error as NSError{
                print(error)
                isSaved = false
            }
            
        }else if(type == "jpg" || type == "jpeg")
        {
            do{
                try
                    UIImageJPEGRepresentation(image, 1.0)?.write(to: URL(fileURLWithPath: chatDirPath.appendingPathComponent("\(imageName).jpg")), options: .atomicWrite)
                isSaved = true
            }catch let error as NSError{
                print(error)
                isSaved = false
            }
        }else{
            print("图片后缀不支持！")
        }
        
        print(chatDirPath.strings(byAppendingPaths: ["\(imageName).png"])[0])
        
        return isSaved
    }
    
    //保存图片到chat目录
    func savaImageToChatCacheDir(_ dirName: String, imageData: Data, imageName: String) -> Bool {
        
        let chatDirPath = createDirInChatCache(dirName)
        
        let imageName = imageName
        var isSaved = Bool()
        
        do{
            try
                imageData.write(to: URL(fileURLWithPath: chatDirPath.appendingPathComponent(imageName)), options: .atomicWrite)
            isSaved = true
        }catch let error as NSError{
            print(error)
            isSaved = false
        }
        
//        print(chatDirPath.stringByAppendingPathComponent(imageName))
        return isSaved
    }
    
    
    // 从chat读取image
    func loadImageFromChatCacheDir(_ dirName: String, imageName: String) -> Data {
        
        let imagePath = createDirInChatCache(dirName).strings(byAppendingPaths: [imageName])[0]
        var imageData = Data()
        if FileManager.default.fileExists(atPath: imagePath) {
            imageData = try! Data(contentsOf: URL(fileURLWithPath: imagePath))
        }
        return imageData
    }
    
    //保存图片到findPets目录
    func savaImageToFindPetsCacheDir(_ image: UIImage, imageName: String, imageType: String) -> Bool {
        let imagePath = createDirInCache(findPetsImageDataSaveFolderName)
        let imageName = imageName
        var isSaved = Bool()
        let type = imageType.lowercased()
        
        if (type == "png"){
            do{
                try
                    UIImagePNGRepresentation(image)?.write(to: URL(fileURLWithPath: imagePath.appendingPathComponent("\(imageName).png")), options: .atomicWrite)
                isSaved = true
            }catch let error as NSError{
                print(error)
                isSaved = false
            }
            
        }else if(type == "jpg" || type == "jpeg"){
            do{
                try
                    UIImageJPEGRepresentation(image, 1.0)?.write(to: URL(fileURLWithPath: imagePath.appendingPathComponent("\(imageName).jpg")), options: .atomicWrite)
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
    func savaImageToFindPetsCacheDir(_ imageData: Data, imageName: String) -> Bool {
        let imagePath = createDirInCache(findPetsImageDataSaveFolderName)
        let imageName = imageName
        var isSaved = Bool()
        
        do{
            try
            imageData.write(to: URL(fileURLWithPath: imagePath.appendingPathComponent(imageName)), options: .atomicWrite)
            isSaved = true
        }catch let error as NSError{
            print(error)
            isSaved = false
        }
        
//        print(imagePath.stringByAppendingPathComponent(imageName))
        return isSaved
    }
    
    
    // 从findpets读取image
    func loadImageFromFindPetsCacheDir(_ imageName: String) -> Data {
        let imagePath = createDirInCache(findPetsImageDataSaveFolderName).strings(byAppendingPaths: [imageName])[0]
        var imageData = Data()
        if FileManager.default.fileExists(atPath: imagePath) {
            imageData = try! Data(contentsOf: URL(fileURLWithPath: imagePath))
//            print(imagePath)
        }
        return imageData
    }
    
    // 从findpets删除image
    func deleteImageFromFindPetsCacheDir(_ imageName: [String]){
        let manager = FileManager.default
        for i in 0 ..<  imageName.count{
        
            let imagePath = createDirInCache(findPetsImageDataSaveFolderName).strings(byAppendingPaths: ["H"+imageName[i]])[0]
//            print(imagePath)
            if manager.fileExists(atPath: imagePath) {
                do{
                    try
                        manager.removeItem(atPath: imagePath)
                    print("删除高清图成功")
                }catch let error as NSError{
                    print("删除高清图失败！")
                    print(error)
                }
                
            }
            
            let imagePath1 = createDirInCache(findPetsImageDataSaveFolderName).strings(byAppendingPaths: [imageName[i]])[0]
            if manager.fileExists(atPath: imagePath1) {
                do{
                    try
                        manager.removeItem(atPath: imagePath1)
                    print("删除普通图成功！")
                }catch let error as NSError{
                    print("删除普通图失败！")
                    print(error)
                }
                
            }
            
        
        }
    }
}