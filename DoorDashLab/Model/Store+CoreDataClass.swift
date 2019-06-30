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
public class Store: NSManagedObject, Decodable {
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
            let ctx = decoder.userInfo[codingUserInfoContextKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Store", in: ctx) else {
                fatalError("Failed to decode Store")
        }

        var optionalSmallInt: Int16?
        var optionalLargeInt: Int32?
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(entity: entity, insertInto: ctx)
        self.name = try container.decode(String.self, forKey: .name)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.coverImageURL = try container.decode(String.self, forKey: .coverImageURL)
        
        // handle possible optionsals that can not be declared optional in the model
        optionalSmallInt = try? container.decode(Int16.self, forKey: .deliveryTime)
        self.deliveryTime = optionalSmallInt ?? 0
        optionalLargeInt = try? container.decode(Int32.self, forKey: .id)
        self.id = optionalLargeInt ?? 0
        optionalSmallInt = try? container.decode(Int16.self, forKey: .deliveryFee)
        self.deliveryFee = optionalSmallInt ?? 0
    }
}

// MARK: - Business logic

extension Store {

    var formattedName: String? {
        guard let name = name else { return "" }
        return name.replacingOccurrences(
            of: "\\(([^\\)]+)\\)",
            with: "",
            options: .regularExpression
        )
    }

    var formattedDeliveryTime: String {
        return String(format: "%i min", deliveryTime)
    }
    
    func formattedDeliveryFee(formatter: Formatter) -> String {
        if deliveryFee == 0 {
            return NSLocalizedString("Free delivery", comment: "Free Delivery")
        } else {
            guard let value = formatter.string(for: Float(deliveryFee/100)) else { return "" }
            return value
        }
    }
}
