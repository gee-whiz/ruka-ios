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

class RegsierCell: UITableViewCell,UITextFieldDelegate  {

    
    @IBOutlet weak var btnRegister: GradientButton!
    @IBOutlet weak var edtPassword: FloatingLabelTextField!
    @IBOutlet weak var edtEmail: FloatingLabelTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
      self.edtPassword.delegate  = self
      self.edtEmail.delegate  = self
    }

    
    
    var callRegister: (() -> ())?
 
    @IBAction func registerTapped(_ sender: Any) {
        self.callRegister!()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.edtPassword.errorMessage  = ""
        self.edtEmail.errorMessage = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
