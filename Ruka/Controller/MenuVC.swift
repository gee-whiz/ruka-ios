//
//  MenuVC.swift
//  Ruka
//
//  Created by George on 2018/04/04.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import MessageUI

struct Menu {
    var title: String!
    var imageName: String!
    var viewController: String!
    
    
}
enum SectionType {
    case A
    case B
    
    
}
struct Sections {
    var type: SectionType
    var items: [Menu]
}


class MenuVC: UIViewController,  UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heroView: UIView!
    var user = [User]()
    @IBOutlet weak var imgProflie: CircleImage!
    var data = [
        Sections(type: .A, items:
            [
                Menu(title:    "Account Details",imageName: "edit_menu",viewController: "ProfileVC"),
                Menu(title:    "List Your Service",imageName: "add_menu",viewController: "AddServiceVC"),
                Menu(title:    "Help",imageName: "help_menu",viewController: "emailVC"),
                Menu(title:    "Login",imageName: "login_menu",viewController: "LoginController")

            ])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate  = self
        self.tableView.dataSource  = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateMenu), name: NSNotification.Name(rawValue: LOGGED_IN_KEY), object: nil)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.editProfile(gestureRecognizer:)))
        self.heroView.addGestureRecognizer(gestureRecognizer)
        self.tableView.tableFooterView = UIView()
        self.presenter  = UserPresenter()
      
    }
    
    override  func viewWillAppear(_ animated: Bool) {
         self.presenter?.getProfile()
    }
    


    var presenter: UserPresenter? {
        didSet {
            presenter?.user.observe {
                [unowned self] (results) in
                if results.count > 0 {
                     self.user = results
                    let item =  self.user[0]
                    self.lblName.text  = item.first_name + " " + item.last_name
                    self.imgProflie.sd_setImage(with: URL(string: item.profile_image_uri), placeholderImage: UIImage(named: "avatar_placeholder"))
                    self.lblName.setNeedsLayout()
                }
            }
        }
    }

    
    
    
    override func viewDidAppear(_ animated: Bool) {
         self.updateMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  data[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.layer.masksToBounds = false
        let item = data[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.imageView?.image  = UIImage(named: item.imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section].items[indexPath.row]

        
        if item.viewController == "LoginController" {
            if AuthenticationService.instance.isLoggedIn {
                self.showAlert(title: "Logout", message: "Are you sure you want to logout?")
                return
            }else{
                let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: item.viewController)
                self.present(vc, animated: true, completion: nil)
            }
        }else if item.viewController == "emailVC" {
            self.sendSupportEmail()
            return
        }else if item.viewController == "ProfileVC" {
            if !(AuthenticationService.instance.isLoggedIn) {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let   vc = storyboard.instantiateViewController(withIdentifier: "LoginController")
                self.present(vc, animated: true, completion: nil)
            }else{
                self.performSegue(withIdentifier: "showProfile", sender: self)
            }
           
            return
        }else{
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: item.viewController)
            self.present(vc, animated: true, completion: nil)
        
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
   }
    
    
    @objc func editProfile(gestureRecognizer: UIGestureRecognizer) {
        if AuthenticationService.instance.isLoggedIn {
           self.performSegue(withIdentifier: "showProfile", sender: self)
        }
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default){ action in
            AuthenticationService.instance.isLoggedIn = false
            AuthenticationService.instance.auth_token = ""
            self.lblName.text = ""
            self.lblName.setNeedsLayout()
            self.updateMenu()
            self.tableView.reloadData()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Request Support
    func sendSupportEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }else{
            let  version:String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
            let messageBody = "\n\n\n\n" + "Help with " + "\n\n\n App name: \(name) \n Version: \(version) \n Device: \(self.deviceName())\n OS version: \(self.osVersion())\n"
            composeVC.setToRecipients(["gkapoya@gmail.com"])
            composeVC.setSubject(NSLocalizedString("email_subject", comment: ""))
            composeVC.setMessageBody(messageBody, isHTML: false)
            present(composeVC, animated: false, completion: nil)
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func osVersion()-> String {
        let version = UIDevice.current.systemVersion
        return  String(version)
    }
    
    func deviceName()-> String{
        return UIDevice.current.modelName
    }
    

    
    @objc func updateMenu() {
        if AuthenticationService.instance.isLoggedIn {
            self.data = [
                Sections(type: .A, items:[
                        Menu(title:    "Account Details",imageName: "edit_menu",viewController: "ProfileVC"),
                        Menu(title:    "List Your Service",imageName: "add_menu",viewController: "AddServiceVC"),
                        Menu(title:    "Help",imageName: "help_menu",viewController: "emailVC"),
                        Menu(title:    "Logout",imageName: "logout_menu",viewController: "LoginController")
                    ])]
            
        }else{
            self.data = [
                Sections(type: .A, items:[
                    Menu(title:    "Account Details",imageName: "edit_menu",viewController: "ProfileVC"),
                    Menu(title:    "List Your Service",imageName: "add_menu",viewController: "AddServiceVC"),
                    Menu(title:    "Help",imageName: "help_menu",viewController: "emailVC"),
                    Menu(title:    "Logout",imageName: "login_menu",viewController: "LoginController")
                    ])]
        }

         self.tableView.reloadData()
    }

}
