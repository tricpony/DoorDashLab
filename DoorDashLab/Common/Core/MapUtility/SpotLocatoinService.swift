//
//  SpotLocatoinService.swift
//  DoorDashLab
//
//  Created by aarthur on 6/29/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit
import MapKit

typealias SpotCompletion = (CLLocationCoordinate2D) -> Void

class SpotLocatoinService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var completion: SpotCompletion? = nil
    var isSuspended = false
    
    func spot(completion: @escaping SpotCompletion) {
        self.completion = completion
        locationManager.delegate = self
        determineAccess()
    }
    
    func suspend() {
        isSuspended = true
        locationManager.stopUpdatingLocation()
    }
    
    func resume() {
        locationManager.startUpdatingLocation()
        isSuspended = false
    }

    private func determineAccess() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            enableLocationServices()
        default:
            return
        }
    }

    private func enableLocationServices() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue = manager.location?.coordinate else { return }
        if let completion = completion, isSuspended == false {
            completion(locationValue)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            suspend()
        case .authorizedWhenInUse:
            enableLocationServices()
        default:
            return
        }
    }
}
