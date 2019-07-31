//
//  ServiceManager.swift
//  DoorDashLab
//
//  Created by aarthur on 6/28/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import Foundation
import Alamofire

/// Struct to centralize service calls
struct ServiceManager {
    
    /// Invokes store search API service
    /// - Parameters:
    ///   - lat: latitude value
    ///   - lng: longiture value
    ///   - completion: call back closure returning either service success with payload or failure
    func startStoreSearchService(lat: Double, lng: Double, completion:@escaping (Swift.Result<Data, Error>)->()) -> SessionManager? {
        guard let url = URL(string: API_Method.store_search.serviceAddress()) else { return nil }
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(7)
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        sessionManager.startRequestsImmediately = false
        sessionManager.request(url,
                          method: .get,
                          parameters: ["lat": lat, "lng": lng])
            .validate()
            .responseData { response in
                guard response.result.isSuccess else {
                    completion(.failure(response.result.error!))
                    return
                }
                completion(.success(response.result.value!))
        }.resume()
        return sessionManager
    }
}
