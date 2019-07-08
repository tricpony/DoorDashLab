//
//  PulsatingLabel.swift
//  DoorDashLab
//
//  Created by aarthur on 6/26/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit

class PulsatingLabel: UILabel {
    func beginAnimations() {
        alpha = 0.75
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse], animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            strongSelf.alpha = 1
            }, completion: { [weak self] _  in
                guard let strongSelf = self else { return }
                strongSelf.transform = CGAffineTransform(scaleX: 1, y: 1)
                strongSelf.alpha = 1
        })
    }

    func endAnimations() {
        layer.removeAllAnimations()
    }
}
