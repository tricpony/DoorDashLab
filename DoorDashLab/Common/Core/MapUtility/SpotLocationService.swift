//
//  SpotLocationService.swift
//  DoorDashLab
//
//  Created by aarthur on 6/29/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit
import MapKit

typealias SpotCompletion = (CLLocationCoordinate2D) -> Void

/// Convenience class to neatly enclose location service
class SpotLocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var completion: SpotCompletion? = nil
    var isSuspended = false
    
    func spot(completion: @escaping SpotCompletion) {
        self.completion = completion
        locationManager.delegate = self
        determineAccess()
    }
    
    /// Stop updating location service
    func suspend() {
        isSuspended = true
        locationManager.stopUpdatingLocation()
    }

    /// Start updating location service
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

    func accessAllowed() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        default:
            return false
        }
    }
    
    private func enableLocationServices() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
