//
//  DraggablePlacemark.swift
//  DoorDashLab
//
//  Created by aarthur on 6/29/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit
import MapKit
import Contacts

typealias RefreshCompletion = (DraggablePlacemark?) -> Void

/// Custom map annotation class that can be updated as the pin is dragged
class DraggablePlacemark: NSObject, MKAnnotation {
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark? = nil
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
        set {
            coord = newValue
        }
    }

    init(coordinate: CLLocationCoordinate2D, placemark: CLPlacemark) {
        super.init()
        self.placemark = placemark
        self.coordinate = coordinate
    }
    
    var title: String? {
        return NSLocalizedString("Delivering To:", comment: "Delivering To:")
    }
    
    /// Provide components of an address in an array
    var addressLines: [String]? {
        guard let addr = placemark?.postalAddress else { return nil }
        let blankLine = ""
        var lines = [addr.street, String(format: "%@ %@, %@", addr.city, addr.state, addr.postalCode)]
        if let name = placemark?.name, name != addr.street {
            lines.insert(contentsOf: [blankLine, name], at: 0)
        } else {
            lines.insert(blankLine, at: 0)
        }
        return lines
    }
    
    /// Provide address on one line
    var flatAddress: String? {
        guard let addr = placemark?.postalAddress else { return nil }
        return String(format: "%@, %@, %@, %@", addr.street, addr.city, addr.state, addr.postalCode)
    }

    /// Update the annotation after drag
    /// - Parameters:
    ///   - view: Annotation view that needs to be refreshed
    func refreshPin(_ view: MKAnnotationView, completion: @escaping RefreshCompletion) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: coord.latitude, longitude: coord.longitude)) { [weak self] (placemarks, error) in
            self?.placemark = placemarks?.last
            view.loadCustomLines(customLines: self?.addressLines ?? [])
            completion(self)
        }
    }
}
