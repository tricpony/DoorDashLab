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

class ExploreMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, DDNavigationBarAppearance {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectedAddressLabel: UILabel!
    let spotService = SpotLocatoinService()
    var coordinate: CLLocationCoordinate2D? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavItems()
        title = NSLocalizedString("Choose an Address", comment: "Choose an Address")
        spotService.spot { [weak self] location in
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: location, span: span)
            self?.mapView.setRegion(region, animated: true)
            self?.spotService.suspend()
            self?.pinMap(at: location)
            self?.coordinate = location
        }
    }

    /// Pins the map at the user's current location
    /// - Parameters:
    ///   - at: Latitude & longitude location of user
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
            selectedAddressLabel.text = placemark.flatAddress
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
            // move pin out from under finger
            view.transform = view.transform.translatedBy(x: 0, y: -15)
        case .ending, .canceling:
            view.transform = CGAffineTransform.identity
            view.dragState = .none
            guard let placemark = view.annotation as? WrappedPlacemark else {return }
            coordinate = placemark.coordinate
            placemark.refreshPin(view) { [weak self] placemark in
                self?.selectedAddressLabel.text = placemark?.flatAddress
            }
        default:
            return
        }
    }
    
    // MARK: - Storyboard

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            guard let tabVC = segue.destination as? UITabBarController else { return }
            guard let viewControllers = tabVC.viewControllers else { return }
            guard let navVC = viewControllers.first as? UINavigationController else { return }
            guard let vc = navVC.topViewController as? ExploreViewController else { return }
            vc.coordinate = coordinate
        }
    }

}
