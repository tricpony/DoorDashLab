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

class PrettyPlacemark: MKPlacemark {
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    override var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
        set {
            coord = newValue
        }
    }

    init(coordinate: CLLocationCoordinate2D, placemark: CLPlacemark) {
        super.init(placemark: placemark)
        self.coordinate = coordinate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var title: String? {
        return "Delivering To:"
    }
    
    var addressLines: [String]? {
        guard let addr = postalAddress else { return nil }
        let blankLine = ""
        var lines = [addr.street, String(format: "%@ %@, %@", addr.city, addr.state, addr.postalCode)]
        if let name = name, name != addr.street {
            lines.insert(contentsOf: [blankLine, name], at: 0)
        } else {
            lines.insert(blankLine, at: 0)
        }
        return lines
    }
}
