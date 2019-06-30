//
//  ExploreMapViewControllerTests.swift
//  DoorDashLabTests
//
//  Created by aarthur on 6/30/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import XCTest
import MapKit
@testable import DoorDashLab

class ExploreMapViewControllerTests: XCTestCase {
    var exploreMapViewController: ExploreMapViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "ExploreMapViewController", bundle: nil)
        exploreMapViewController = storyboard.instantiateViewController(withIdentifier: "ExploreMapScene") as? ExploreMapViewController
        _ = exploreMapViewController.view
    }

    override func tearDown() {
        super.tearDown()
        exploreMapViewController = nil
    }

    func testTitle() {
        let title = "My Title"
        exploreMapViewController.title = title
        XCTAssertEqual(title, exploreMapViewController.title)
    }
    
    func testAddressOfCurrentLocationIsNotEmpty() {
        let expectation = XCTestExpectation(description: "Verify that address is set.")
        let mockDelegate = MockMapViewDelegate()
        mockDelegate.expectation = expectation
        mockDelegate.exploreMapViewController = exploreMapViewController
        exploreMapViewController.mapView.delegate = mockDelegate
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(exploreMapViewController.selectedAddressLabel.text!.isEmpty)
    }
}

class MockMapViewDelegate: NSObject, MKMapViewDelegate {
    var exploreMapViewController: ExploreMapViewController!
    var expectation: XCTestExpectation!

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "DoorDash"
        if let pin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            return pin
        } else {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            guard let placemark = annotation as? DraggablePlacemark else {return pin }
            pin.calloutOffset = CGPoint(x: -10, y: -7)
            pin.canShowCallout = true
            pin.animatesDrop = true
            pin.isDraggable = true
            pin.loadCustomLines(customLines: placemark.addressLines ?? [])
            exploreMapViewController.selectedAddressLabel.text = placemark.flatAddress
            expectation.fulfill()
            return pin
        }
    }
}
