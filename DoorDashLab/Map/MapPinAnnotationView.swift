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
    
    func configure(pinInfo: DraggablePlacemark) {
        calloutOffset = CGPoint(x: -10, y: -7)
        canShowCallout = true
        animatesDrop = true
        isDraggable = true
        loadCustomLines(customLines: pinInfo.addressLines ?? [])
    }
}
