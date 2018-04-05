//
//  RootViewController.swift
//  Ruka
//
//  Created by George on 2018/03/13.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

 
    
    override  func viewDidAppear(_ animated: Bool) {
        if AuthenticationService.instance.isLoggedIn {
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "mainVC")
            self.present(vc, animated: false, completion: nil)
        }else{
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginController")
            self.present(vc, animated: false, completion: nil)
        }
    }
    



}
