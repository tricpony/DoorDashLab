//
//  MapPinAnnotationView.swift
//  DoorDashLab
//
//  Created by aarthur on 7/1/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit
import MapKit

class MapPinAnnotationView: MKPinAnnotationView {
    static let pin_id = "MapPinAnnotationView"
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityStateZipLabel: UILabel!
    
    class func loadNib() -> MapPinAnnotationView? {
        let nib = UINib(nibName: "MapAnnotation", bundle: nil)
        guard let pin = nib.instantiate(withOwner: nil, options: nil)[0] as? MapPinAnnotationView else { return nil }
        return pin
    }
/*
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
*/
    func configure(pinInfo: DraggablePlacemark) {
        calloutOffset = CGPoint(x: -10, y: -7)
        canShowCallout = true
        animatesDrop = true
        isDraggable = true
        guard let addr = pinInfo.placemark?.postalAddress else { return }
        streetLabel.text = addr.street
        cityStateZipLabel.text = String(format: "%@ %@, %@", addr.city, addr.state, addr.postalCode)
    }
}
