//
//  SaveDataModel.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/26.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import UIKit

class SaveDataModel: NSObject {
    
//＊＊＊＊＊＊＊＊＊＊＊＊＊用户配置文件＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    
    func setUserData(key: String, value: Any){
        //1、 保存
        UserDefaults.standard.set(value, forKey: key)
        //2、同步
        UserDefaults.standard.synchronize()
    }
    
    func getUserData(key: String) -> Any?{
        //取值
        if let value = UserDefaults.standard.object(forKey: key){
            return value
        }else{
            return nil
        }
    }
    
//＊＊＊＊＊＊＊＊＊＊＊＊＊聊天设置数据＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //聊天设置保存数据
    func saveChatSettingToTempDirectory(settingData: [MainChatListViewDataSettingModel]){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)  //申明一个归档处理对象
        //这里的key每个都要不相同，不然会有很大的问题
        archiver.encode(settingData, forKey: "ChatSettingData")
        archiver.finishEncoding()  //编码结束
        
        let path = self.getChatSettingDataFilePath()
        data.write(toFile: path, atomically: true)
    }
    
    //聊天读取数据
    func loadChatSettingDataFromTempDirectory() -> [MainChatListViewDataSettingModel] {
        var dataChatData = [MainChatListViewDataSettingModel]()
        
        //获取本地数据文件地址
        let path = self.getChatSettingDataFilePath()
        //声明文件管理器
        let defaultManager = FileManager.default
        
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExists(atPath: path) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))  //读取文件数据
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)   //解码器
                dataChatData = unarchiver.decodeObject(forKey: "ChatSettingData") as! [MainChatListViewDataSettingModel]  //通过归档时设置的关键字还原
                unarchiver.finishDecoding()  //结束解码
            }catch let e as NSError{
                logger.info("聊天数据读取失败！")
                logger.info(e)
            }
            
        }else{
            logger.info("聊天设置文件不存在")
        }
        return dataChatData
    }
    
    //获取聊天数据文件地址
    func getChatSettingDataFilePath() -> String{
        return self.getChatDirectory().appendingPathComponent("ChatSettingData.plist")
    }
    
    
//＊＊＊＊＊＊＊＊＊＊＊＊＊聊天数据＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //聊天保存数据
    func saveChatsToTempDirectory(chatData: [ChatData], fileName: String, key: String){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)  //申明一个归档处理对象
        //这里的key每个都要不相同，不然会有很大的问题
        archiver.encode(chatData, forKey: key)
        archiver.finishEncoding()  //编码结束
        
        let path = getChatDataFilePath(fileName)
        data.write(toFile: path, atomically: true)
    }
    
    //删除聊天文件
    func deleteChatsPListFile(_ fileName: String){
        
        let path = getChatDataFilePath(fileName)  //获取本地数据文件地址
        let defaultManager = FileManager.default   //声明文件管理器
        
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExists(atPath: path) {
            do{
                try defaultManager.removeItem(atPath: path)
                    logger.info("删除本地"+fileName+".plist文件成功！")
            }catch let error as NSError{
                logger.info("删除本地"+fileName+".plist文件失败！")
                logger.info(error)
            }
        }
    }
    
    //聊天读取数据
    func loadChatsDataFromTempDirectory(_ fileName: String, key: String) -> [ChatData] {
        var dataChatData = [ChatData]()
        
        //获取本地数据文件地址
        let path = getChatDataFilePath(fileName)
        //声明文件管理器
        let defaultManager = FileManager.default
        
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExists(atPath: path) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))  //读取文件数据
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)   //解码器
                dataChatData = unarchiver.decodeObject(forKey: key) as! [ChatData]  //通过归档时设置的关键字还原
                unarchiver.finishDecoding()  //结束解码
            }catch let e as NSError{
                logger.info("聊天数据读取失败！")
                logger.info(e)
            }
            
        }else{
            logger.info(fileName+"的ChatData文件不存在")
        }
        return dataChatData
    }
    
    //获取沙盒文件夹路径
    func getDocumentsDirectory() -> AnyObject {
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentationDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)
        let documentsDirectory = paths[0]
        return documentsDirectory as AnyObject
    }
    
    //获取聊天数据文件夹路径
    //withIntermediateDirectories 设置为true， 代表中间所有的路径目录如果不存在，都会创建
    func getChatDirectory() -> AnyObject {
        let path = self.getDocumentsDirectory().strings(byAppendingPaths: [chatDataSaveFolderName])[0]
        //不存在就创建
        if (!FileManager.default.fileExists(atPath: path)) {
            do{
                _ = try
                    FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }catch _ as NSError{
                return "" as AnyObject
            }
        }
        return path as AnyObject
    }
    
    //获取聊天数据文件地址
    func getChatDataFilePath(_ fileName: String) -> String{
        return self.getChatDirectory().appendingPathComponent(fileName)
    }

//＊＊＊＊＊＊＊＊＊＊＊＊＊寻宠数据＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    
    //获取附近寻宠数据文件地址
    func getFindMyPetsDataFilePath() -> String{
        return self.getFindMyPetsDirectory().appendingPathComponent(FindMyPetsDataSaveFileName)
    }
    
    //获取附近寻宠页数据文件夹路径
    //withIntermediateDirectories 设置为true， 代表中间所有的路径目录如果不存在，都会创建
    func getFindMyPetsDirectory() -> AnyObject {
        let path = self.getDocumentsDirectory().strings(byAppendingPaths: [FindMyPetsDataSaveFolderName])[0] 
        //不存在就创建
        if (!FileManager.default.fileExists(atPath: path)) {
            do{
                _ = try
                    FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }catch _ as NSError{
                return "" as AnyObject
            }
        }
        return path as AnyObject
    }
    
    //保存寻宠数据
    func saveFindMyPetsToTempDirectory(_ findPetsCellModelData: [FindPetsCellModel]){
        
        let data = NSMutableData()
        //申明一个归档处理对象
        let archiver = NSKeyedArchiver(forWritingWith: data)
        //将lists以对应Checklist关键字进行编码
        archiver.encode(findPetsCellModelData, forKey: "FindMyPetsDataArray")
        
        //编码结束
        archiver.finishEncoding()
        
        let path = getFindMyPetsDataFilePath()
        
        data.write(toFile: path, atomically: true)
    }
    
    //读取寻宠数据
    func loadFindMyPetsDataFromTempDirectory() -> [FindPetsCellModel] {
        var dataFindPetsCellModel = [FindPetsCellModel]()
        
        //获取本地数据文件地址
        let path = getFindMyPetsDataFilePath()
        //声明文件管理器
        let defaultManager = FileManager.default
        
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExists(atPath: path) {
            //读取文件数据
            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
            //解码器
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data!)
            //通过归档时设置的关键字Checklist还原lists
            dataFindPetsCellModel = unarchiver.decodeObject(forKey: "FindMyPetsDataArray") as! [FindPetsCellModel]
            
            //结束解码
            unarchiver.finishDecoding()
        }else{
            logger.info("FindMyPetsData 文件不存在")
        }
        return dataFindPetsCellModel
    }

}
