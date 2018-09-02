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

    override func awakeFromNib() {
        super.awakeFromNib()

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
