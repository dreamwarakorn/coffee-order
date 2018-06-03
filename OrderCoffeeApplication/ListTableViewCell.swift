//
//  ListTableViewCell.swift
//  OrderCoffeeApplication
//
//  Created by Warakorn Rungseangthip on 24/4/2561 BE.
//  Copyright © 2561 Warakorn Rungseangthip. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    
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
