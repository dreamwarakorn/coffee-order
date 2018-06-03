//
//  TableViewCell.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 19/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgView.layer.cornerRadius = imgView.bounds.height / 2
        imgView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
