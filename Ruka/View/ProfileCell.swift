//
//  ProfileCell.swift
//  Ruka
//
//  Created by George on 2018/04/07.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var edtFirstName: FloatingLabelTextField!
    
    
    @IBOutlet  var edtAbout: UIFloatLabelTextView!
    @IBOutlet weak var edtPhone: UITextField!
    @IBOutlet weak var edtEmail: UITextField!
    @IBOutlet weak var edtLastName: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.edtEmail.delegate  = self
        self.edtAbout.delegate = self
        self.edtPhone.delegate  = self
        self.edtLastName.delegate  = self
        self.edtFirstName.delegate  = self
        
       self.edtAbout.placeholder = "ABOUT"
        self.edtAbout.translatesAutoresizingMaskIntoConstraints = false
        self.edtAbout.placeholderTextColor = UIColor.lightGray
        self.edtAbout.floatLabelActiveColor = #colorLiteral(red: 0.9537598491, green: 0.2608756125, blue: 0.4666399956, alpha: 1)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
