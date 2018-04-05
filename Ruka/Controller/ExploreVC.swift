//
//  ExploreVC.swift
//  Ruka
//
//  Created by George on 2018/04/04.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit

class ExploreVC: UIViewController {

    @IBOutlet weak var btnMenu: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
