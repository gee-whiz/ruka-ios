//
//  ServiceDetail.swift
//  Ruka
//
//  Created by George on 2018/04/08.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit

class ServiceDetail: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var service: Service!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight =  self.view.frame.height + 50
        let imageView = UIImageView()
        imageView.frame  = CGRect(x: 0, y: 0, width: self.tableView.frame.size.height, height: 300)
        imageView.contentMode  = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.sd_setImage(with: URL(string: self.service.image_uri), placeholderImage: UIImage(named: "coming_soon"))
      
        let headerView: ParallaxHeaderView = ParallaxHeaderView.parallaxHeaderView(with: imageView.image, for: CGSize(width: self.tableView.frame.size.width, height: self.tableView.frame.size.height / 2)) as! ParallaxHeaderView
        self.tableView.tableHeaderView = headerView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.title  = self.service.name
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailCell", for: indexPath) as! ServiceDetailCell
            cell.layer.masksToBounds = false
            
            cell.lblname.text = self.service.name
            cell.lblPrice.text  = self.service.price
               return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "seviceDescriiption", for: indexPath) as! ServiceDetailCell
             cell.layer.masksToBounds = false
            cell.lblLocation.text  = self.service.address
            cell.lblServiceDescription.text = self.service.service_description
      
            
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
    
    
    @IBAction func btnChatTapped(_ sender: Any) {
        if !(AuthenticationService.instance.isLoggedIn) {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let   vc = storyboard.instantiateViewController(withIdentifier: "LoginController")
            self.present(vc, animated: true, completion: nil)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let   vc = storyboard.instantiateViewController(withIdentifier: "ChatVC")
            self.revealViewController().setFront(vc, animated: true)
        }
     
    }
    
    
    func  scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let header: ParallaxHeaderView = self.tableView.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderView(forScrollOffset: scrollView.contentOffset)
        self.tableView.tableHeaderView = header
    }

}
