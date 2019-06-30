//
//  ExploreViewController.swift
//  DoorDashLab
//
//  Created by aarthur on 6/28/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import MagicalRecord

/// Class to display results of store search API service
class ExploreViewController: UITableViewController, SizeClass {
    lazy var managedObjectContext: NSManagedObjectContext = {
        MagicalRecord.setupCoreDataStack(withStoreNamed:"DoorDashLab")
        return NSManagedObjectContext.mr_default()
    }()
    lazy var currencyFormatter: Formatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = NSLocale.current
        return currencyFormatter
    }()
    private var stores = [Store]()
    var coordinate: CLLocationCoordinate2D? = nil
    var hasStores: Bool { // strictly for unit testing
        return stores.isEmpty == false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //this will prevent bogus separator lines from displaying in an empty table
        tableView.tableFooterView = UIView()
        //enable auto cell height that uses constraints
        self.tableView.rowHeight = UITableView.automaticDimension
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performStoreService()
    }

    /// Invoke store search API service
    func performStoreService() {
        guard let coordinate = coordinate else { return }
        ServiceManager().startStoreSearchService(lat: coordinate.latitude, lng: coordinate.longitude) { [weak self] data, error in
            if let data = data {
                guard let fetchedStores = JsonUtility<Store>.parseJSON(data, ctx: self?.managedObjectContext) else { return }
                self?.stores = fetchedStores
                self?.tableView.reloadData()
                self?.managedObjectContext.mr_saveToPersistentStore(completion: nil)
            } else {
                let message = NSLocalizedString("There was a problem with your request.  Please try again later.", comment: "Service error alert")
                self?.presentOkAlert(title: NSLocalizedString("Alert", comment: "Alert"),
                               message: message,
                               completion: nil)
            }
        }
    }

    // MARK: - Table View
    
    func cellIdentifier(at indexPath: IndexPath) -> String {
        return "ExploreTableCell"
    }
    
    func nextCellForTableView(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(at: indexPath))
        
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: self.cellIdentifier(at: indexPath))
        }
        
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.nextCellForTableView(tableView, at: indexPath) as! ExploreTableCell
        let store = stores[indexPath.row]
        cell.fillCell(store, currencyFormatter)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sizeClass().horizontal == .compact {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
