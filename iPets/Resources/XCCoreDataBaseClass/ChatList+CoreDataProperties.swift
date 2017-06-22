//
//  ChatList+CoreDataProperties.swift
//  
//
//  Created by maocaiyuan on 2017/6/22.
//
//

import Foundation
import CoreData


extension ChatList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatList> {
        return NSFetchRequest<ChatList>(entityName: "ChatList")
    }

    @NSManaged public var icon: NSData?
    @NSManaged public var lable: String?
    @NSManaged public var nickname: String?
    @NSManaged public var time: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var unread: String?

}
