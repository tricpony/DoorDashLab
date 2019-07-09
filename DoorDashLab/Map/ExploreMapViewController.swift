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

/// Class to display a map with a draggable pin defaulting to the current location of device
class ExploreMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectedAddressLabel: UILabel!
    let spotService = SpotLocationService()
    var coordinate: CLLocationCoordinate2D? = nil

    func registerMapAssets() {
        mapView.register(MapPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: MapPinAnnotationView.pin_id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerMapAssets()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyStyle()
    }
    
    func applyStyle() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    /// Pins the map at the user's current location
    /// - Parameters:
    ///   - at: Latitude & longitude location of user
    func pinMap(at: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: at.latitude, longitude: at.longitude)) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?.last else { return }
            self?.mapView.addAnnotation(DraggablePlacemark(coordinate: at, placemark: placemark))
        }
    }
    
    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = MapPinAnnotationView.pin_id
        guard let placemark = annotation as? DraggablePlacemark else { return nil }
        selectedAddressLabel.text = placemark.flatAddress
        
        if let pin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MapPinAnnotationView {
            pin.configure(pinInfo: placemark)
            return pin
        } else {
            let pin = MapPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pin.configure(pinInfo: placemark)
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
            guard let placemark = view.annotation as? DraggablePlacemark else {return }
            coordinate = placemark.coordinate
            placemark.refreshPin(view) { [weak self] placemark in
                self?.selectedAddressLabel.text = placemark?.flatAddress
            }
        default:
            return
        }
    }
    
    // MARK: - Unwind
    
    @IBAction func prepareForUnwind(seque: UIStoryboardSegue) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)]
        seque.source.tabBarController?.navigationController?.navigationBar.titleTextAttributes = textAttributes
        seque.source.tabBarController?.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    // MARK: - Storyboard

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            guard let tabVC = segue.destination as? UITabBarController else { return }
            guard let viewControllers = tabVC.viewControllers else { return }
            guard let navVC = viewControllers.first as? UINavigationController else { return }
            guard let vc = navVC.topViewController as? ExploreViewController else { return }
            vc.coordinate = coordinate
            
            // setup nav bar
            let backButtonImage = #imageLiteral(resourceName: "nav-address")
            let imageView = UIImageView(image: backButtonImage)
            let tapGesture = UITapGestureRecognizer(target: vc, action: #selector(ExploreViewController.pop(_:)))
            
            imageView.addGestureRecognizer(tapGesture)
            let backBarButton = UIBarButtonItem(customView: imageView)
            tabVC.navigationItem.setHidesBackButton(true, animated: false)
            tabVC.navigationItem.leftBarButtonItem = backBarButton
        }
    }

}
