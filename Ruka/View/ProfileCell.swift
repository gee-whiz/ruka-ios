//
//  ProfileCell.swift
//  Ruka
//
//  Created by George on 2018/04/07.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import GrowingTextView

class ProfileCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var edtFirstName: UITextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var edtAbout: GrowingTextView!
    @IBOutlet weak var edtText: UITextField!
    
//    @IBOutlet weak var edtAbout: GrowingTextView!
//
//    @IBOutlet weak var edtPhone: UITextField!
//    @IBOutlet weak var edtEmail: UITextField!
//    @IBOutlet weak var edtLastName: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // self.edtText.delegate  = self
        
//        self.edtEmail.delegate  = self
//        self.edtAbout.delegate = self
//        self.edtPhone.delegate  = self
//        self.edtLastName.delegate  = self
//        self.edtFirstName.delegate  = self
//        self.edtEmail.applyBorder()
//        self.edtFirstName.applyBorder()
//        self.edtLastName.applyBorder()
//        self.edtPhone.applyBorder()
//        self.edtAbout.placeholder  =  "Comments"
//        self.edtAbout.layer.cornerRadius  = 5.0
//        self.edtAbout.layer.borderWidth  = 1.0
//        self.edtAbout.layer.borderColor  = #colorLiteral(red: 0.3082081974, green: 0.1841563582, blue: 0.1004526243, alpha: 1).cgColor.copy(alpha: 1)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? FloatingLabelTextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }

}
