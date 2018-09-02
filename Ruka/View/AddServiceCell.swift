//
//  AddServiceCell.swift
//  Ruka
//
//  Created by George on 2018/04/08.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import GrowingTextView

class AddServiceCell: UITableViewCell , UITextFieldDelegate, UITextViewDelegate{
   
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var edtText: UITextField!
    @IBOutlet weak var edtAbout: GrowingTextView!
    override func awakeFromNib() {
        super.awakeFromNib()

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
