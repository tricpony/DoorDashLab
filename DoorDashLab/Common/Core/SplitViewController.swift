//
//  SplitViewController.swift
//  DoorDashLab
//
//  Created by aarthur on 6/28/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate, SizeClass {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.preferredDisplayMode = .allVisible
    }

    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        let screenSizeClass = sizeClass()
        if screenSizeClass.horizontal == .regular && screenSizeClass.vertical == .regular {
            return false
        }
        return true
    }
}
