//
//  AddServiceCell.swift
//  Ruka
//
//  Created by George on 2018/04/08.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit

class AddServiceCell: UITableViewCell , UITextFieldDelegate, UITextViewDelegate{
    @IBOutlet weak var edtAbout: UIFloatLabelTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.edtAbout.placeholder = "DESCRIPTION"
        self.edtAbout.translatesAutoresizingMaskIntoConstraints = false
        self.edtAbout.placeholderTextColor = UIColor.lightGray
        self.edtAbout.floatLabelActiveColor = #colorLiteral(red: 0.9537598491, green: 0.2608756125, blue: 0.4666399956, alpha: 1)
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
