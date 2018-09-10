//
//  ReviewsCell.swift
//  Beauty Cart
//
//  Created by George on 2018/09/08.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import Cosmos

class ReviewsCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var rattingView: CosmosView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: CircleImage!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
