//
//  UIViewController+Alerts.swift
//  DoorDashLab
//
//  Created by aarthur on 6/29/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import Foundation
import UIKit

/// Enum representing the tapped button of an alert panel
public enum SelectedButton: Int {
    case buttonOne
    case buttonTwo
    public typealias AlertHandler = (SelectedButton) -> Void
}

extension UIViewController {

    /// Convenience method to present alert panels
    /// - Parameters:
    ///   - title: title of panel
    ///   - message: message of panel
    ///   - buttonTitles: array of titles to display as buttons in panel
    ///   - completion: call back closure triggered when a button is tapped
    func presentAlert(title: String?, message: String?, buttonTitles: [String], completion: SelectedButton.AlertHandler?) {
        guard buttonTitles.count > 0 else { return }
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttonTitles.forEach { title in
            let buttonIndex = buttonTitles.firstIndex(of: title) ?? 0
            let selectedButton = SelectedButton(rawValue: buttonIndex) ?? .buttonOne
            let buttonAction = UIAlertAction(title: title, style: .default, handler: { _ in
                if let safeHandler = completion {
                    safeHandler(selectedButton)
                }
            })
            actionSheetController.addAction(buttonAction)
        }
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    /// Convenience method to present an OK alert panel
    /// - Parameters:
    ///   - title: title of panel
    ///   - message: message of panel
    ///   - completion: call back closure triggered when a button is tapped
    func presentOkAlert(title: String, message: String, completion: SelectedButton.AlertHandler?) {
        presentAlert(title: title, message: message, buttonTitles: [NSLocalizedString("OK", comment: "OK")], completion: completion)
    }
}
