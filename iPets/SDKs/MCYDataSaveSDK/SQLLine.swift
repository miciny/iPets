
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



//chatList的数据库
let entityNameOfChatList = "ChatList"

//contectors的数据库
let entityNameOfContectors = "Contectors"

//searchRecord的数据库
let entityNameOfSearchRecord = "SearchRecord"



class SQLLine: NSObject{
    
    //所有的数据
    class func SelectAllData(_ entityName: String) -> NSArray{
        
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
    class func DeleteData(_ entityName: String, condition: String) -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        
        let predicate = NSPredicate(format: condition, "")
        request.predicate = predicate
        
        var flag = false
        do{
            //查询满足条件的
            let resultsList = try allDataSource.fetch(request) as NSArray
            if resultsList.count != 0 {//若结果为多条，则只删除第一条，可根据你的需要做改动
                allDataSource.delete(resultsList[0] as! NSManagedObject)
                try allDataSource.save()
                print("删除成功~ ~")
                flag = true
            }else{
                print("删除失败！ 没有符合条件:" + condition)
                flag = true
            }
        }catch{
            print("删除失败!")
            flag = false
        }
        
        return flag
    }
    
    //删所有数据
    class func DeleteAllData(_ entityName: String) -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var flag = false
        
        let data = SQLLine.SelectAllData(entityName)
        
        if data.count > 0{
            do {
                for i in 0 ..< data.count{
                    allDataSource.delete(data[i] as! NSManagedObject)
                }
                try allDataSource.save()
                print("删除成功~ ~")
                flag = true
                
            }catch _ as NSError{
                flag = false
            }
        }else{
            flag = true
        }
        
        return flag
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
    
    //改一条的某个数据
    class func UpdateDataWithCondition(_ condition: String, entityName: String, changeValue: AnyObject, changeEntityName: String) -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        
        let predicate = NSPredicate(format: condition, "")
        request.predicate = predicate
        
        var flag = false
        do{
            //查询满足条件的
            let resultsList = try allDataSource.fetch(request) as NSArray
            if resultsList.count != 0 {
                (resultsList[0] as AnyObject).setValue(changeValue, forKey: changeEntityName)
                try allDataSource.save()
                print("更新成功~ ~")
                flag = true
            }else{
                print("更新失败！ 没有符合条件:" + condition)
                flag = true
            }
        }catch{
            print("更新失败 !")
            flag = false
        }
        
        return flag
    }
    
    
    
    //searchrecord查询一条数据, 有就返回数据
    class func SelectedCordData(_ condition: String, entityName: String) -> NSArray?{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        
        let predicate = NSPredicate(format: condition, "")
        request.predicate = predicate
        do{
            //查询满足条件的
            let resultsList = try allDataSource.fetch(request) as NSArray
            return resultsList
        }catch{
            print("查询失败 !")
            return nil
        }
    }
    
    
    //======================================chatlist================================
    
    //chatlist插入一条数据
    class func InsertChatListData(_ title: String, lable: String, icon: Data, time: Date, nickname: String, unread: Int) -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let row = NSEntityDescription.insertNewObject(forEntityName: entityNameOfChatList, into: allDataSource) as! ChatList
        
        row.title = title
        row.lable = lable
        row.icon = icon as NSData
        row.time = time as NSDate
        row.nickname = nickname
        row.unread = unread as NSNumber
        
        return saveData()
    }
    
    
    //======================================contectors================================
    
    //contectors插入一条数据
    class func InsertContectorsData(_ name: String, icon: Data, nickname: String, sex: String, remark: String, address: String, http: String) -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let row = NSEntityDescription.insertNewObject(forEntityName: entityNameOfContectors, into: allDataSource) as! Contectors
        
        row.name = name
        row.icon = icon as NSData
        row.nickname = nickname
        row.sex = sex
        row.remark = remark
        row.address = address
        row.http = http
        
        return saveData()
    }
    
    //======================================searchrecord================================
    
    //searchrecord插入一条数据
    class func InsertSearchrecordData(_ label: String, time: Date) -> Bool{
        let allDataSource = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let row = NSEntityDescription.insertNewObject(forEntityName: entityNameOfSearchRecord, into: allDataSource) as! SearchRecord
        
        row.label = label
        row.time = time as NSDate
        return saveData()
    }
}
