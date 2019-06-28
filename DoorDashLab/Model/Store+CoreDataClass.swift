//
//  Store+CoreDataClass.swift
//  DoorDashLab
//
//  Created by aarthur on 6/28/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

@objc(Store)
public class Store: NSManagedObject {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case summary = "description"
        case deliveryFee = "delivery_fee"
        case coverImageURL = "cover_img_url"
        case deliveryTime = "asap_time"
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoContextKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[codingUserInfoContextKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Store", in: managedObjectContext) else {
                fatalError("Failed to decode Store")
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(entity: entity, insertInto: managedObjectContext)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.deliveryFee = try container.decode(Int16.self, forKey: .deliveryFee)
        self.coverImageURL = try container.decode(String.self, forKey: .coverImageURL)
        self.deliveryTime = try container.decode(Int16.self, forKey: .deliveryTime)
    }

}
