//
//  JsonUtility.swift
//  DoorDashLab
//
//  Created by aarthur on 6/28/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import Foundation
import CoreData

struct JsonUtility<T: Decodable> {

    static func parseJSON(_ payload: Data?, ctx: NSManagedObjectContext? = nil) -> [T]? {
        if payload == nil {
            return nil
        }

        let decoder = JSONDecoder()
        guard let ctx = ctx else { fatalError() }
        guard let codingUserInfoContextKey = CodingUserInfoKey.context else { fatalError() }
        decoder.userInfo[codingUserInfoContextKey] = ctx

        do {
            let decoded = try decoder.decode([T].self, from: payload!)
            return decoded
        } catch let error {
            print(error)
        }
        return nil
    }
}
