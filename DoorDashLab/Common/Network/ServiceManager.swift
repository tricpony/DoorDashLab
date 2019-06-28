//
//  ServiceManager.swift
//  DoorDashLab
//
//  Created by aarthur on 6/28/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import Foundation
import Alamofire

func startStoreSearchService(method: API_Method, lat: Double, lng: Double, completion:@escaping (Data?, Error?)->()) {
    guard let url = URL(string: method.serviceAddress()) else { return }
    Alamofire.request(url,
                      method: .get,
                      parameters: ["lat": lat, "lng": lng])
        .validate()
        .responseData { response in
            guard response.result.isSuccess else {
                print("Service Failed: \(String(describing: response.result.error))")
                completion(nil, response.result.error)
                return
            }
            completion(response.result.value, nil)
    }
}
