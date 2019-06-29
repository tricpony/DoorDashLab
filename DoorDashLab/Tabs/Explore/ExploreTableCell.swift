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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
