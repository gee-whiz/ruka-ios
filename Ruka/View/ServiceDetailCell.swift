//
//  ServiceDetailCell.swift
//  Ruka
//
//  Created by George on 2018/04/08.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit

class ServiceDetailCell: UITableViewCell {

    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnDirection: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblServiceDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnCallTapped(_ sender: Any) {
    }
    
    @IBAction func btnDiretionTapped(_ sender: Any) {
    }
    
    
    @IBAction func btnEmailTapped(_ sender: Any) {
    }
    
}


