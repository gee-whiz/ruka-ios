//
//  RegisterViewController.swift
//  Ruka
//
//  Created by George on 2018/03/17.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        self.setupView()
        self.presenter = AuthenticationPresenter()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight =  self.view.frame.height
    }
    
    
    var presenter: AuthenticationPresenter? {
        didSet {
            presenter?.auth_token.observe {(results) in
                if results.count > 5 {
                    self.presenter?.createUser(emai: AuthenticationService.instance.userEmail)
                }
            }
            presenter?.registerMsg.observe {
                [unowned self] (results) in
                debugPrint(results)
                if results.count > 3 {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            presenter?.errorMsg.observe{(msg) in
                if msg.count > 0 {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    self.showMessage(msg, type: .error)
                }
            }
        }
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegsierCell", for: indexPath) as! RegsierCell
        cell.btnRegister.setTitle("SIGN IN WITH EMAIL/PHONE", for: .normal)
        
        
        cell.callRegister = {
            guard let email = cell.edtEmail.text , cell.edtEmail.hasText else {return
                cell.edtEmail.errorMessage  = "Please enter a valid email address"
                
            }
            if (!(cell.edtEmail.text?.isEmail)!) {
                cell.edtEmail.errorMessage  = "Please enter a valid email address"
                return
            }
            guard let password = cell.edtPassword.text , cell.edtPassword.hasText else {return
                cell.edtPassword.errorMessage = "Please enter password"
            }
            
            self.view.endEditing(true)
            cell.btnRegister.setTitle("", for: .normal)
            let buttonHeight = cell.btnRegister.bounds.size.height
            let buttonWidth =  cell.btnRegister.bounds.size.width
            self.activityIndicator.center  = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            cell.btnRegister.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            
            self.presenter?.registerWithEmail(email: email, password: password)
        }
        
        
        return  cell
        
    }
    
    
    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginController.handleTap))
        self.view.addGestureRecognizer(tap)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
        
    }
    
    @objc func handleTap(){
        self.view.endEditing(true)
    }
    
}
