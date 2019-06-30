//
//  DDNavigationBarAppearance.swift
//  DoorDashLab
//
//  Created by aarthur on 6/30/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import Foundation
import UIKit

protocol DDNavigationBarAppearance where Self: UIViewController {
    func loadNavItems()
}

extension DDNavigationBarAppearance {
    func loadNavItems() {
        var backButtonBackgroundImage = #imageLiteral(resourceName: "nav-address")
        backButtonBackgroundImage = backButtonBackgroundImage.resizableImage(withCapInsets: UIEdgeInsets(top: 0,
                                                                                                         left: backButtonBackgroundImage.size.width - 1,
                                                                                                         bottom: 0,
                                                                                                         right: 0))
        let barAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [UIViewController.self])
        barAppearance.backIndicatorImage = backButtonBackgroundImage
        barAppearance.backIndicatorTransitionMaskImage = backButtonBackgroundImage
        
        // Provide an empty backBarButton to hide the 'Back' text present by default in the back button.
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
    }
}
