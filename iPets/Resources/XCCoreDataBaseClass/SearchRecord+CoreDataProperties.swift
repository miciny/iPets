//
//  SearchRecord+CoreDataProperties.swift
//  
//
//  Created by maocaiyuan on 2017/6/22.
//
//

import Foundation
import CoreData


extension SearchRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchRecord> {
        return NSFetchRequest<SearchRecord>(entityName: "SearchRecord")
    }

    @NSManaged public var label: String?
    @NSManaged public var time: NSDate?

}
