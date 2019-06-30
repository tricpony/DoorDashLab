//
//  ExploreTableCell.swift
//  DoorDashLab
//
//  Created by aarthur on 6/29/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import UIKit

/// Custom table cell class to display each store
class ExploreTableCell: UITableViewCell {
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeSummaryLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var pinWheel: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        storeSummaryLabel.textColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        deliveryFeeLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    }

    /// Fill out cell content
    /// - Parameters:
    ///   - store: model object containing store details
    ///   - currencyFormatter: formatter used on delivery fee
    func fillCell(_ store: Store, _ currencyFormatter: Formatter) {
        storeNameLabel.text = store.formattedName
        storeSummaryLabel.text = store.summary
        deliveryFeeLabel.text = store.formattedDeliveryFee(formatter: currencyFormatter)
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
