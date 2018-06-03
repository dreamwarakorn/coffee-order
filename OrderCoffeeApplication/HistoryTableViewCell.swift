//
//  HistoryTableViewCell.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 3/5/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
