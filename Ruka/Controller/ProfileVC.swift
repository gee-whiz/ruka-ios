//
//  ProfileVC.swift
//  Ruka
//
//  Created by George on 2018/04/05.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMenu: UIButton!
     var activityIndicator = UIActivityIndicatorView()
    var data  = [User]()
    var email: String = ""
    var first_name = ""
    var last_name = ""
    var about: String = " "
    var phone: String = ""
    var profile_image_uri: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginController.handleTap))
        self.view.addGestureRecognizer(tap)
        self.activityIndicator.startAnimating()
        self.tableView.tableFooterView = UIView()
        self.presenter  = UserPresenter()
        self.presenter?.getProfile()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight =  self.view.frame.height - 150
        
    }

 
    
    
    var presenter: UserPresenter? {
        didSet {
            presenter?.user.observe {
                [unowned self] (results) in
                self.data = results.count > 0 ? results : []
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.btnDone.loadingIndicator(show: false)
                self.btnDone.setTitle("Edit", for: .normal)
            }
            presenter?.errorMsg.observe { (error) in
                self.view.setNeedsLayout()
                if error.count > 0 {
                    self.activityIndicator.stopAnimating()
                    self.btnDone.loadingIndicator(show: false)
                    self.btnDone.setTitle("Done", for: .normal)
                }
                
            }
            
            presenter?.updateMsg.observe { (msg) in
                self.view.setNeedsLayout()
                if msg.count > 0 {
                    self.btnDone.loadingIndicator(show: false)
                    self.btnDone.setTitle("Edit", for: .normal)
                    self.showMessage(msg, type: .success)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.edtEmail.delegate  = self
        cell.edtAbout.delegate = self
        cell.edtPhone.delegate  = self
        cell.edtLastName.delegate  = self
        cell.edtFirstName.delegate  = self
        let item = self.data[indexPath.row]
        cell.edtFirstName.text  = item.first_name
        cell.edtLastName.text  = item.last_name

        cell.edtPhone.text  = item.phone
        cell.edtEmail.text  = item.email
  
        if item.about.count > 0 {
             cell.edtAbout.text  =  item.about 
        }
      
        self.first_name  = item.first_name
        self.last_name  = item.last_name
        self.about  = item.about
        self.phone = item.phone
        self.email  = item.email
        self.profile_image_uri  = item.profile_image_uri
        
        
    
        return cell
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        
        if btnDone.titleLabel?.text == "Done" {
             self.view.endEditing(true)
            self.presenter?.updateUser(email: self.email, first_name: self.first_name, last_name: self.last_name, about: self.about, phone: self.phone, profile_image_uri: self.profile_image_uri)
            self.btnDone.setTitle("", for: .normal)
            self.btnDone.loadingIndicator(show: true)
           
            self.resignFirstResponder()
        }else{
            let allTextField = getTextfield(view: self.view)
            for txtField in allTextField{
                if txtField.tag == 0 {
                    txtField.becomeFirstResponder()
                }
            }
        }
    }
    
    func getTextfield(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfield(view: subview)
            }
        }
        return results
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ =  textField as! FloatingLabelTextField
            if textField.tag  == 0  {
                self.first_name = textField.text!
            }else if textField.tag == 1 {
                self.last_name  = textField.text!
            }else if textField.tag  == 2{
                self.email  = textField.text!
            }else if textField.tag  == 3{
                self.phone  = textField.text!
            }
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
          _ = textView as! UIFloatLabelTextView
          self.about  = textView.text!
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.btnDone.setTitle("Done", for: .normal)
        self.btnDone.isEnabled   = true
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor  = UIColor.black
        
        self.btnDone.setTitle("Done", for: .normal)
        self.btnDone.isEnabled   = true
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

}
