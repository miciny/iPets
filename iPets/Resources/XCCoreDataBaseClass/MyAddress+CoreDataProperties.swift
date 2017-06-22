//
//  MyAddress+CoreDataProperties.swift
//  
//
//  Created by maocaiyuan on 2017/6/22.
//
//

import Foundation
import CoreData


extension MyAddress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyAddress> {
        return NSFetchRequest<MyAddress>(entityName: "MyAddress")
    }

    @NSManaged public var address: String?
    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?

}
