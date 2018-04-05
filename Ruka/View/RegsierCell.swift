//
//  RegsierCell.swift
//  Ruka
//
//  Created by George on 2018/03/31.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class RegsierCell: UITableViewCell {

    
    @IBOutlet weak var btnRegister: GradientButton!
    @IBOutlet weak var edtPassword: FloatingLabelTextField!
    @IBOutlet weak var edtEmail: FloatingLabelTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    
    
    var callRegister: (() -> ())?
 
    @IBAction func registerTapped(_ sender: Any) {
        self.callRegister!()
    }
    
}
