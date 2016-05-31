
//
//  SAQL.swift
//  iPets
//
//  Created by maocaiyuan on 16/3/23.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SQLLine: NSObject{
    
    //所有的数据
    class func SelectAllData(entityName:String) -> NSArray{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest(entityName: entityName)
        do {
            _ = try
                textData =  allDataSource.executeFetchRequest(fetchData)
        }catch _ as NSError{
            let toast = ToastView()
            toast.showToast("读取数据失败！")
        }
        return textData
    }
    
    //删一条数据
    class func DeleteData(entityName:String,indexPath:Int) -> Bool{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var data = NSArray()
        data = SQLLine.SelectAllData(entityName)
        allDataSource.deleteObject(data[indexPath] as! NSManagedObject)
        return saveData()
    }
    
    //save，返回成功或者失败
    class func saveData() -> Bool{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        do {
            _ = try
                allDataSource.save()
            return true
        }catch _ as NSError{
            return false
        }
    }
    
    //SettingData插入一条数据
    class func InsertSettingData(pic: NSData, name: String, nickname: String, sex: String, address: String, motto: String) -> Bool{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfSettingData, inManagedObjectContext: allDataSource)
        
        row.setValue(pic, forKey: settingDataNameOfMyIcon)
        row.setValue(name, forKey: settingDataNameOfMyName)
        row.setValue(nickname, forKey: settingDataNameOfMyNickname)
        row.setValue(sex, forKey: settingDataNameOfMySex)
        row.setValue(address, forKey: settingDataNameOfMyAddress)
        row.setValue(motto, forKey: settingDataNameOfMyMotto)
        
        return saveData()
    }
    //SettingData改一条的某个数据
    class func UpdateSettingData(indexPath: Int, changeValue: AnyObject, changeEntityName: String) -> Bool{
        var data = NSArray()
        data = SQLLine.SelectAllData(entityNameOfSettingData)
        
        data[indexPath].setValue(changeValue, forKey: changeEntityName)
        return saveData()
    }
    
    //chatlist插入一条数据
    class func InsertChatListData(title: String, lable: String, icon: NSData, time: NSDate, nickname: String) -> Bool{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfChatList, inManagedObjectContext: allDataSource)
        
        row.setValue(title, forKey: ChatListNameOfTitle)
        row.setValue(lable, forKey: ChatListNameOfLable)
        row.setValue(icon, forKey: ChatListNameOfIcon)
        row.setValue(time, forKey: ChatListNameOfTime)
        row.setValue(nickname, forKey: ChatListNameOfNickname)
        
        return saveData()
    }
    //chatlist改一条的某个数据
    class func UpdateChatListData(indexPath: Int, changeValue: AnyObject, changeEntityName: String) -> Bool{
        var data = NSArray()
        data = SelectAllData(entityNameOfChatList)
        
        data[indexPath].setValue(changeValue, forKey: changeEntityName)
        return saveData()
    }
    
    //contectors插入一条数据
    class func InsertContectorsData(name: String, icon: NSData, nickname: String, sex: String, remark: String, address: String, http: String) -> Bool{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfContectors, inManagedObjectContext: allDataSource)
        
        row.setValue(name, forKey: ContectorsNameOfName)
        row.setValue(icon, forKey: ContectorsNameOfIcon)
        row.setValue(sex, forKey: ContectorsNameOfSex)
        row.setValue(remark, forKey: ContectorsNameOfRemark)
        row.setValue(nickname, forKey: ContectorsNameOfNickname)
        row.setValue(address, forKey: ContectorsNameOfAddress)
        row.setValue(http, forKey: ContectorsNameOfHttp)
        
        return saveData()
    }
    //contectors改一条的某个数据
    class func UpdateContectorsData(indexPath: Int, changeValue: AnyObject, changeEntityName: String) -> Bool{
        var data = NSArray()
        data = SelectAllData(entityNameOfContectors)
        
        data[indexPath].setValue(changeValue, forKey: changeEntityName)
        return saveData()
    }
    
    //searchrecord插入一条数据
    class func InsertSearchrecordData(label: String, time: NSDate) -> Bool{
        let allDataSource = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let row : AnyObject = NSEntityDescription.insertNewObjectForEntityForName(entityNameOfSearchRecord, inManagedObjectContext: allDataSource)
        
        row.setValue(label, forKey: SearchRecordNameOfLabel)
        row.setValue(time, forKey: SearchRecordNameOfTime)
        
        return saveData()
    }
    //searchrecord改一条的某个数据
    class func UpdateSearchrecordData(indexPath: Int, changeValue: AnyObject, changeEntityName: String) -> Bool{
        var data = NSArray()
        data = SelectAllData(entityNameOfSearchRecord)
        
        data[indexPath].setValue(changeValue, forKey: changeEntityName)
        return saveData()
    }
}