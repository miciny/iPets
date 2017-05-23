
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
    class func SelectAllData(_ entityName:String) -> NSArray{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var textData : NSArray = []
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            _ = try
                textData =  allDataSource.fetch(fetchData) as NSArray
        }catch _ as NSError{
            let toast = ToastView()
            toast.showToast("读取数据失败！")
        }
        return textData
    }
    
    //删一条数据
    class func DeleteData(_ entityName:String,indexPath:Int) -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var data = NSArray()
        data = SQLLine.SelectAllData(entityName)
        allDataSource.delete(data[indexPath] as! NSManagedObject)
        return saveData()
    }
    
    //save，返回成功或者失败
    class func saveData() -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        do {
            _ = try
                allDataSource.save()
            return true
        }catch _ as NSError{
            return false
        }
    }
    
    
    //======================================SettingData================================
    
    //SettingData插入一条数据
    class func InsertSettingData(_ pic: Data, name: String, nickname: String, sex: String, address: String, motto: String) -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let row : AnyObject = NSEntityDescription.insertNewObject(forEntityName: entityNameOfSettingData, into: allDataSource)
        
        row.setValue(pic, forKey: settingDataNameOfMyIcon)
        row.setValue(name, forKey: settingDataNameOfMyName)
        row.setValue(nickname, forKey: settingDataNameOfMyNickname)
        row.setValue(sex, forKey: settingDataNameOfMySex)
        row.setValue(address, forKey: settingDataNameOfMyAddress)
        row.setValue(motto, forKey: settingDataNameOfMyMotto)
        
        return saveData()
    }
    //SettingData改一条的某个数据
    class func UpdateSettingData(_ indexPath: Int, changeValue: AnyObject, changeEntityName: String) -> Bool{
        var data = NSArray()
        data = SQLLine.SelectAllData(entityNameOfSettingData)
        
        (data[indexPath] as AnyObject).setValue(changeValue, forKey: changeEntityName)
        return saveData()
    }
    
    //======================================chatlist================================
    
    //chatlist插入一条数据
    class func InsertChatListData(_ title: String, lable: String, icon: Data, time: Date, nickname: String) -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let row : AnyObject = NSEntityDescription.insertNewObject(forEntityName: entityNameOfChatList, into: allDataSource)
        
        row.setValue(title, forKey: ChatListNameOfTitle)
        row.setValue(lable, forKey: ChatListNameOfLable)
        row.setValue(icon, forKey: ChatListNameOfIcon)
        row.setValue(time, forKey: ChatListNameOfTime)
        row.setValue(nickname, forKey: ChatListNameOfNickname)
        
        return saveData()
    }
    //chatlist改一条的某个数据
    class func UpdateChatListData(_ indexPath: Int, changeValue: AnyObject, changeEntityName: String) -> Bool{
        var data = NSArray()
        data = SelectAllData(entityNameOfChatList)
        
        (data[indexPath] as AnyObject).setValue(changeValue, forKey: changeEntityName)
        return saveData()
    }
    
    
    //======================================contectors================================
    
    //contectors插入一条数据
    class func InsertContectorsData(_ name: String, icon: Data, nickname: String, sex: String, remark: String, address: String, http: String) -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let row : AnyObject = NSEntityDescription.insertNewObject(forEntityName: entityNameOfContectors, into: allDataSource)
        
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
    class func UpdateContectorsData(_ indexPath: Int, changeValue: AnyObject, changeEntityName: String) -> Bool{
        var data = NSArray()
        data = SelectAllData(entityNameOfContectors)
        
        (data[indexPath] as AnyObject).setValue(changeValue, forKey: changeEntityName)
        return saveData()
    }
    
    
    //======================================searchrecord================================
    
    //searchrecord插入一条数据
    class func InsertSearchrecordData(_ label: String, time: Date) -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let row : AnyObject = NSEntityDescription.insertNewObject(forEntityName: entityNameOfSearchRecord, into: allDataSource)
        
        row.setValue(label, forKey: SearchRecordNameOfLabel)
        row.setValue(time, forKey: SearchRecordNameOfTime)
        
        return saveData()
    }
    //searchrecord改一条的某个数据
    class func UpdateSearchrecordData(_ indexPath: Int, changeValue: AnyObject, changeEntityName: String) -> Bool{
        var data = NSArray()
        data = SelectAllData(entityNameOfSearchRecord)
        
        (data[indexPath] as AnyObject).setValue(changeValue, forKey: changeEntityName)
        return saveData()
    }
}
