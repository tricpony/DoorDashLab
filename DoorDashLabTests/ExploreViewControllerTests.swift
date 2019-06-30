//
//  ExploreViewControllerTests.swift
//  DoorDashLabTests
//
//  Created by aarthur on 6/30/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import XCTest
import MapKit
import CoreData
@testable import DoorDashLab

class ExploreViewControllerTests: XCTestCase {
    var exploreViewController: ExploreViewController!
    var featuresViewController: FavoritesViewController!
    let spotService = SpotLocatoinService()
    var fetchedResultsController: NSFetchedResultsController<Store>!
    lazy var request: NSFetchRequest<Store> = {
        let request = NSFetchRequest<Store>(entityName: "Store")
        let sortOrder = NSSortDescriptor.init(key: "name", ascending: true)
        request.sortDescriptors = [sortOrder]
        return request
    }()

    func loadExploreController() {
        let storyboard = UIStoryboard(name: "ExploreViewController", bundle: nil)
        exploreViewController = storyboard.instantiateViewController(withIdentifier: "ExploreScene") as? ExploreViewController
        _ = exploreViewController.view
    }
    
    func loadFavoritesController() {
        let storyboard = UIStoryboard(name: "FavoritesViewController", bundle: nil)
        featuresViewController = storyboard.instantiateViewController(withIdentifier: "FavoritesScene") as? FavoritesViewController
        _ = featuresViewController.view
    }
    
    func testDataSourceNotEmpty() {
        let expectationA = XCTestExpectation(description: "Verify spot location fired.")
        var coordinate: CLLocationCoordinate2D? = nil

        spotService.spot { location in
            coordinate = location
            expectationA.fulfill()
        }
        wait(for: [expectationA], timeout: 1.0)
        guard let location = coordinate else {
            XCTFail("Spot service failed.")
            return
        }
        loadExploreController()
        let delegate = MockFetchResultsControllerDelegate()
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: exploreViewController.managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        let expectationB = XCTestExpectation(description: "Wait for API call.")
        delegate.expectation = expectationB
        fetchedResultsController.delegate = delegate
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            fatalError("Unresolved error \(error)")
        }
        exploreViewController.coordinate = location
        exploreViewController.viewWillAppear(false)
        wait(for: [expectationB], timeout: 5.0)
        XCTAssertTrue(exploreViewController.hasStores)
        loadFavoritesController()
        XCTAssertTrue(featuresViewController.hasStores)
    }
}

class MockFetchResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
    var expectation: XCTestExpectation!
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        expectation.fulfill()
    }
}
