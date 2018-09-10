//
//  PromotionsCell.swift
//  Beauty Cart
//
//  Created by George on 2018/09/07.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit

class PromotionsCell: UITableViewCell {

    @IBOutlet weak var promotionsList: PromotionsList!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configure(del:PromotionItem?){
        promotionsList.selectionDelegate = del
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
