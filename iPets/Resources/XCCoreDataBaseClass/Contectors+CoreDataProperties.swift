//
//  Contectors+CoreDataProperties.swift
//  
//
//  Created by maocaiyuan on 2017/6/22.
//
//

import Foundation
import CoreData


extension Contectors {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contectors> {
        return NSFetchRequest<Contectors>(entityName: "Contectors")
    }

    @NSManaged public var address: String?
    @NSManaged public var http: String?
    @NSManaged public var icon: NSData?
    @NSManaged public var name: String?
    @NSManaged public var nickname: String?
    @NSManaged public var remark: String?
    @NSManaged public var sex: String?

}
