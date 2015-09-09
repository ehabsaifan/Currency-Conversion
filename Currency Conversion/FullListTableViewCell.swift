//
//  FullListTableViewCell.swift
//  Currency Conversion
//
//  Created by Ehab Saifan on 8/25/15.
//  Copyright (c) 2015 DeAnza. All rights reserved.
//

import UIKit

class FullListTableViewCell: UITableViewCell {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
