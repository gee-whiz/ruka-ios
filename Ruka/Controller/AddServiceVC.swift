//
//  AddServiceVC.swift
//  Ruka
//
//  Created by George on 2018/04/08.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import SwiftValidator
import GrowingTextView


class AddServiceVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UINavigationControllerDelegate, UITextViewDelegate, ValidationDelegate  {
  
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var btnPost: GradientButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMenu: UIButton!
    var activityIndicator = UIActivityIndicatorView()
    var data = [DynamicField(title:    "Title",value: "", tag: 0,keyType: UIKeyboardType.default),
                DynamicField(title:    "Availability",value: "",tag: 1,keyType: UIKeyboardType.default),
                DynamicField(title:    "Minimum Price",value: "",tag: 2,keyType: UIKeyboardType.numbersAndPunctuation),
                DynamicField(title:    "Location",value: "",tag: 3,keyType: UIKeyboardType.default),
                DynamicField(title:    "Email",value: "",tag: 4,keyType: UIKeyboardType.emailAddress),
                DynamicField(title:    "Phone",value: "", tag: 5, keyType: UIKeyboardType.phonePad),
                DynamicField(title:    "Description",value: "", tag: 6,keyType: UIKeyboardType.default)]
    let validator = Validator()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.rowHeight = 50
        self.tableView.estimatedRowHeight =  50
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginController.handleTap))
        self.view.addGestureRecognizer(tap)
        validator.styleTransformers(success:{ (validationRule) -> Void in
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            if validationRule.field is UITextField {

            }
        }, error:{ (validationError) -> Void in
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                 textField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 2, revert: true)
            }
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnCancelTapped(_ sender: Any) {
        self.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    override  func viewWillAppear(_ animated: Bool) {
        if !(AuthenticationService.instance.isLoggedIn) {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let   vc = storyboard.instantiateViewController(withIdentifier: "LoginController")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return  6
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddServiceCell", for: indexPath)as! AddServiceCell
            cell.layer.masksToBounds = false
             let item = self.data[indexPath.row]
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            self.validator.registerField(cell.edtText, errorLabel: cell.lblError, rules: [RequiredRule()])
            cell.edtText.delegate = self
            cell.edtText.tag  = item.tag
            cell.lblTitle.text = item.title
            cell.edtText.text = item.value
            cell.edtText.placeholder  = item.title
            cell.edtText.keyboardType = item.keyType
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddServiceCell2", for: indexPath)as! AddServiceCell
            cell.layer.masksToBounds = false
             let item = self.data[6]
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.edtAbout.delegate = self
            cell.edtAbout.tag  = item.tag
            cell.lblTitle.text = item.title
            cell.edtAbout.placeholder  = item.title
            cell.edtAbout.tintColor  = #colorLiteral(red: 0.3082081974, green: 0.1841563582, blue: 0.1004526243, alpha: 1)
 
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return  60
        }
        return  70
    }
    
    @IBAction func btnPostTapped(_ sender: Any) {
        self.validator.validate(self)
        
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        self.validator.validate(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if let nextField = textField.superview?.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    @objc func handleTap(){
        self.view.endEditing(true)
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ =  textField
        if textField.tag  == 0  {
            self.data[0].value = textField.text!
        }else if textField.tag == 1 {
            self.data[1].value   = textField.text!
        }else if textField.tag  == 2 {
            self.data[2].value   = textField.text!
        }else if textField.tag  == 3 {
            self.data[3].value   = textField.text!
        }else if textField.tag  == 4 {
            self.data[4].value   = textField.text!
        }else if textField.tag  == 5 {
            self.data[5].value   = textField.text!
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        _ = textView as! GrowingTextView
        self.data[6].value   = textView.text!
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        _ = textView as! GrowingTextView
        self.data[6].value   = textView.text!
    }

    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos"{
            let vc = segue.destination as! PhotosCollectionViewController
            vc.data = self.data
        }
    }
    
 
    func validationSuccessful() {
         self.performSegue(withIdentifier: "showPhotos", sender: self)
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, _) in errors {
            if let field = field as? UITextField {
              field.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 2, revert: true)

            }
        }
    }
    
    
    
    
}
