//
//  SplitViewController.swift
//  DoorDashLab
//
//  Created by aarthur on 6/28/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        return false
    }
}
