//
//  ExploreTableCell.swift
//  DoorDashLab
//
//  Created by aarthur on 6/29/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit

class ExploreTableCell: UITableViewCell {
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeStyleLabel: UILabel!
    @IBOutlet weak var deliveryChargeLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var pinWheel: UIActivityIndicatorView!

    func fillCell(_ store: Store, _ currencyFormatter: Formatter) {
        storeNameLabel.text = store.formattedName
        storeStyleLabel.text = store.summary
        deliveryChargeLabel.text = store.formattedDeliveryFee(formatter: currencyFormatter)
        deliveryTimeLabel.text = store.formattedDeliveryTime
        guard let coverImageURL = store.coverImageURL else { return }
        guard let url = URL(string: coverImageURL) else { return }
        pinWheel.startAnimating()
        URLImage.fetchImageURL(url) { [weak self] image, response, error in
            if let image = image {
                self?.logoImageView.image = image
                self?.pinWheel.stopAnimating()
            }
        }
    }
}
