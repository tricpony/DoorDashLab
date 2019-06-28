//
//  API.swift
//  DoorDashLab
//
//  Created by aarthur on 6/28/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import Foundation

enum API_Method: String {
    case store_search

    func serviceAddress() -> String {
        return API.endPoint + self.rawValue + "/"
    }
}

struct API {
    static let endPoint = "https://api.doordash.com/"

}
