//
//  ServiceDetail.swift
//  Ruka
//
//  Created by George on 2018/04/08.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import MessageUI

class ServiceDetail: UIViewController,  UITableViewDelegate,MFMailComposeViewControllerDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var service: Service!
    var reviewList = [Review]()
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
        self.tableView.register(UINib(nibName: "ReviewsCell", bundle: nil), forCellReuseIdentifier: "ReviewsCell")
        self.presenter = ServicePresenter()
        self.presenter?.getReviews(serviceId: self.service._id)
        
    }
    
    
    var presenter: ServicePresenter? {
        didSet {
            presenter?.review.observe {
                [unowned self] (results) in
                self.reviewList = results.count > 0 ? results : []
                self.tableView.reloadData()

                
            }
            presenter?.errorMsg.observe { (error) in
                self.view.setNeedsLayout()
                if error.count > 0 {

                }
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        self.title  = self.service.name
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            return self.reviewList.count
        }
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailCell", for: indexPath) as! ServiceDetailCell
            cell.layer.masksToBounds = false
            cell.callEmail = {
                self.sendEmail(email: self.service.email_address, subject: self.service.name)
            }
            
            cell.callPhone = {
                self.service.phone.makeACall()
            }
            
            cell.callShare = {
                let text = "Please check out this: \n\n\(self.service.service_description!) \n\n Email: \(self.service.email_address!)"
                self.displayShareSheet(shareContent: text)
            }
            cell.lblname.text = self.service.name
            cell.lblPrice.text  = self.service.price.convertCurrency()
               return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "seviceDescriiption", for: indexPath) as! ServiceDetailCell
             cell.layer.masksToBounds = false
            cell.lblLocation.text  = self.service.address
            cell.lblServiceDescription.text = self.service.service_description
              return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsCell", for: indexPath) as! ReviewsCell
            let review  = self.reviewList[indexPath.row]
            cell.lblName.text = review.user_name
            cell.lblTitle.text  = review.title
            cell.lblText.text  = review.text
            cell.rattingView.rating  = review.rattings as! Double
            
            return  cell
            
        }
     
      return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 8
        }else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "\(self.reviewList.count) Reviews"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as? UITableViewHeaderFooterView
        headerView?.backgroundColor = UIColor.white
        headerView?.textLabel?.textColor = #colorLiteral(red: 0.3082081974, green: 0.1841563582, blue: 0.1004526243, alpha: 1)
    }

    // MARK: - sent email
    func sendEmail(email: String, subject: String) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        if !MFMailComposeViewController.canSendMail() {
            return
        }else{
            composeVC.setToRecipients([email])
            composeVC.setSubject(subject)
            composeVC.setMessageBody("", isHTML: false)
            present(composeVC, animated: false, completion: nil)
        }
        
    }
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func  scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let header: ParallaxHeaderView = self.tableView.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderView(forScrollOffset: scrollView.contentOffset)
        self.tableView.tableHeaderView = header
    }

}
