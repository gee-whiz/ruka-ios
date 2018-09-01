//
//  AddServiceScndCell.swift
//  Ruka
//
//  Created by George on 2018/04/08.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import GrowingTextView

class AddServiceScndCell: UITableViewCell,UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var btnPost: GradientButton!
    @IBOutlet weak var edtAvailability: UITextField!
    @IBOutlet weak var edtPhone: UITextField!
    @IBOutlet weak var edtLocation: UITextField!
    @IBOutlet weak var edtMinPrice: UITextField!
    
    @IBOutlet weak var edtTitle: UITextField!
    @IBOutlet weak var edtAbout: GrowingTextView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.edtPhone.applyBorder()
        self.edtPhone.delegate = self
        self.edtLocation.applyBorder()
        self.edtLocation.delegate = self
        self.edtMinPrice.applyBorder()
        self.edtMinPrice.delegate = self
        self.edtAvailability.applyBorder()
        self.edtAvailability.delegate = self
        self.edtAbout.placeholder  =  "Description"
        self.edtAbout.layer.cornerRadius  = 5.0
        self.edtAbout.layer.borderWidth  = 1.0
        self.edtAbout.layer.borderColor  = #colorLiteral(red: 0.3082081974, green: 0.1841563582, blue: 0.1004526243, alpha: 1).cgColor.copy(alpha: 1)
        self.edtTitle.applyBorder()
        self.edtTitle.delegate = self
        
        
    }

    @IBAction func btnPostTapped(_ sender: Any) {
        debugPrint("ggkgkgkg")
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
