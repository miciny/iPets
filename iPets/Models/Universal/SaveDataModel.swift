//
//  SaveDataModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/26.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SaveDataModel: NSObject {
    
//＊＊＊＊＊＊＊＊＊＊＊＊＊聊天数据＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //聊天保存数据
    func saveChatsToTempDirectory(chatData: [ChatData], fileName: String, key: String){
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)  //申明一个归档处理对象
        
        //这里的key每个都要不相同，不然会有很大的问题
        archiver.encodeObject(chatData, forKey: key)
        archiver.finishEncoding()  //编码结束
        
        let path = getChatDataFilePath(fileName)
        data.writeToFile(path, atomically: true)
    }
    
    //删除聊天文件
    func deleteChatsPListFile(fileName: String){
        
        let path = getChatDataFilePath(fileName)  //获取本地数据文件地址
        let defaultManager = NSFileManager.defaultManager()   //声明文件管理器
        
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExistsAtPath(path) {
            do{
                try
                    defaultManager.removeItemAtPath(path)
                    print("删除本地plist文件成功！")
            }catch let error as NSError{
                print("删除本地plist文件失败！")
                print(error)
            }
        }

    }
    
    //聊天读取数据
    func loadChatsDataFromTempDirectory(fileName: String, key : String) -> [ChatData] {
        var dataChatData = [ChatData]()
        
        //获取本地数据文件地址
        let path = getChatDataFilePath(fileName)
        //声明文件管理器
        let defaultManager = NSFileManager.defaultManager()
        
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExistsAtPath(path) {
            let data = NSData(contentsOfFile: path)  //读取文件数据
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)   //解码器
            dataChatData = unarchiver.decodeObjectForKey(key) as! [ChatData]  //通过归档时设置的关键字还原
            unarchiver.finishDecoding()  //结束解码
        }else{
            print("ChatData 文件不存在")
        }
        return dataChatData
    }
    
    //获取沙盒文件夹路径
    func getDocumentsDirectory() -> AnyObject {
        let paths = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentationDirectory,NSSearchPathDomainMask.UserDomainMask,true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //获取聊天数据文件夹路径
    //withIntermediateDirectories 设置为true， 代表中间所有的路径目录如果不存在，都会创建
    func getChatDirectory() -> AnyObject {
        let path = self.getDocumentsDirectory().stringByAppendingPathComponent(chatDataSaveFolderName)
        //不存在就创建
        if (!NSFileManager.defaultManager().fileExistsAtPath(path)) {
            do{
                _ = try
                    NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            }catch _ as NSError{
                return ""
            }
        }
        return path
    }
    
    //获取聊天数据文件地址
    func getChatDataFilePath(fileName: String) -> String{
        return self.getChatDirectory().stringByAppendingPathComponent(fileName)
    }

//＊＊＊＊＊＊＊＊＊＊＊＊＊寻宠数据＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    
    //获取附近寻宠数据文件地址
    func getFindMyPetsDataFilePath() -> String{
        return self.getFindMyPetsDirectory().stringByAppendingPathComponent(FindMyPetsDataSaveFileName)
    }
    
    //获取附近寻宠页数据文件夹路径
    //withIntermediateDirectories 设置为true， 代表中间所有的路径目录如果不存在，都会创建
    func getFindMyPetsDirectory() -> AnyObject {
        let path = self.getDocumentsDirectory().stringByAppendingPathComponent(FindMyPetsDataSaveFolderName)
        //不存在就创建
        if (!NSFileManager.defaultManager().fileExistsAtPath(path)) {
            do{
                _ = try
                    NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            }catch _ as NSError{
                return ""
            }
        }
        return path
    }
    
    //保存寻宠数据
    func saveFindMyPetsToTempDirectory(findPetsCellModelData: [FindPetsCellModel]){
        
        let data = NSMutableData()
        //申明一个归档处理对象
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        //将lists以对应Checklist关键字进行编码
        archiver.encodeObject(findPetsCellModelData, forKey: "FindMyPetsDataArray")
        
        //编码结束
        archiver.finishEncoding()
        
        let path = getFindMyPetsDataFilePath()
        
        data.writeToFile(path, atomically: true)
    }
    
    //读取寻宠数据
    func loadFindMyPetsDataFromTempDirectory() -> [FindPetsCellModel] {
        var dataFindPetsCellModel = [FindPetsCellModel]()
        
        //获取本地数据文件地址
        let path = getFindMyPetsDataFilePath()
        //声明文件管理器
        let defaultManager = NSFileManager.defaultManager()
        
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExistsAtPath(path) {
            //读取文件数据
            let data = NSData(contentsOfFile: path)
            //解码器
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
            //通过归档时设置的关键字Checklist还原lists
            dataFindPetsCellModel = unarchiver.decodeObjectForKey("FindMyPetsDataArray") as! [FindPetsCellModel]
            
            //结束解码
            unarchiver.finishDecoding()
        }else{
            print("FindMyPetsData 文件不存在")
        }
        return dataFindPetsCellModel
    }

}
