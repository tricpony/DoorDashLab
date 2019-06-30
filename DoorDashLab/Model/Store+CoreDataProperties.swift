//
//  Store+CoreDataProperties.swift
//  DoorDashLab
//
//  Created by aarthur on 6/28/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//
//

import Foundation
import CoreData


extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store")
    }

    @NSManaged public var createDate: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var summary: String?
    @NSManaged public var deliveryFee: Int16
    @NSManaged public var coverImageURL: String?
    @NSManaged public var deliveryTime: Int16
    @NSManaged public var favorite: Bool

}
