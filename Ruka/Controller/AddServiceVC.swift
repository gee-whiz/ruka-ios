//
//  AddServiceVC.swift
//  Ruka
//
//  Created by George on 2018/04/08.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit

class AddServiceVC: UIViewController,UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var btnPost: GradientButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMenu: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight =  self.view.frame.height
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddServiceCell", for: indexPath) as! AddServiceCell
            cell.layer.masksToBounds = false
    
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdderviceScndCell", for: indexPath)as! AddServiceScndCell
            cell.layer.masksToBounds = false
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 8
        }else{
            return 0
        }
    }
    
    
    @IBAction func btnPostTapped(_ sender: Any) {
    }
    
    
    
    
}
