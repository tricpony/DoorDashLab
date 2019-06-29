//
//  PrettyPlacemark.swift
//  DoorDashLab
//
//  Created by aarthur on 6/29/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class WrappedPlacemark: NSObject, MKAnnotation {
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var placemark: CLPlacemark? = nil
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
        return "Delivering To:"
    }
    
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
    
    func refreshPin(_ view: MKAnnotationView) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: coord.latitude, longitude: coord.longitude)) { [weak self] (placemarks, error) in
            self?.placemark = placemarks?.last
            view.loadCustomLines(customLines: self?.addressLines ?? [])
        }
    }
}
