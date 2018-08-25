//
//  LoginCell.swift
//  Ruka
//
//  Created by George on 2018/03/17.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class LoginCell: UITableViewCell, UITextFieldDelegate  {

    @IBOutlet weak var loginView: UIView!

    @IBOutlet weak var btnRegister: GradientButton!
    @IBOutlet weak var btnLogin: GradientButton!
    @IBOutlet weak var edtPassword: FloatingLabelTextField!
    @IBOutlet weak var edtEmail: FloatingLabelTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.edtEmail.delegate  = self
        self.edtPassword.delegate  = self
    
    }

    var callRegister: (() -> ())?
    var callLogin: (() -> ())?
    @IBAction func loginTapped(_ sender: Any) {
        self.callLogin! ()
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        self.callRegister! ()
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
