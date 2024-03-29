//
//  FavoritesViewController.swift
//  DoorDashLab
//
//  Created by aarthur on 6/28/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord

/// Class to display all stores fetched so far
class FavoritesViewController: UITableViewController, SizeClass {
    lazy var currencyFormatter: Formatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = NSLocale.current
        return currencyFormatter
    }()
    private var stores: [Store] {
        return Store.mr_find(byAttribute: "favorite", withValue: true) as! [Store]
    }
    var hasStores: Bool { // strictly for unit testing
        return stores.isEmpty == false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUI()
    }

    func applyStyle() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)]
        tabBarController?.navigationController?.navigationBar.titleTextAttributes = textAttributes
        tabBarController?.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    func configUI() {
        applyStyle()
        tabBarController?.navigationItem.title = "Favorites"
        //this will prevent bogus separator lines from displaying in an empty table
        tableView.tableFooterView = UIView()
        //enable auto cell height that uses constraints
        self.tableView.rowHeight = UITableView.automaticDimension
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
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
