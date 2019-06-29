//
//  ExploreMapViewController.swift
//  DoorDashLab
//
//  Created by aarthur on 6/28/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class ExploreMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let spotService = SpotLocatoinService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spotService.spot { [weak self] location in
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: location, span: span)
            self?.mapView.setRegion(region, animated: true)
            self?.spotService.suspend()
            self?.pinMap(at: location)
        }
    }

    func pinMap(at: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: at.latitude, longitude: at.longitude)) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?.last else { return }
            self?.mapView.addAnnotation(WrappedPlacemark(coordinate: at, placemark: placemark))
        }
    }
    
    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "DoorDash"
        if let pin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            return pin
        } else {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            guard let placemark = annotation as? WrappedPlacemark else {return pin }
            pin.calloutOffset = CGPoint(x: -10, y: -7)
            pin.canShowCallout = true
            pin.animatesDrop = true
            pin.isDraggable = true
            pin.loadCustomLines(customLines: placemark.addressLines ?? [])
            return pin
        }
    }

    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 didChange newState: MKAnnotationView.DragState,
                 fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
            guard let placemark = view.annotation as? WrappedPlacemark else {return }
            placemark.refreshPin(view)
        default:
            return
        }
    }


//    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//        guard let pin = views.first else { return }
//        pin.setSelected(true, animated: true)
//    }
}
