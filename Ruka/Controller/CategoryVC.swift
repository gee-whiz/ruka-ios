//
//  CategoryVCViewController.swift
//  Beauty Cart
//
//  Created by George on 2018/09/07.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import SafariServices
import  SkeletonView

class CategoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource, CategoryItem,PromotionItem {
   
    @IBOutlet weak var tableView: UITableView!
    var categoryList = [Category]()
    var promotionList = [Promotion]()
    var category: Category!
    var promotion: Promotion!
    var selectionDelegate : CategoryItem?
    var promotionDelegate : PromotionItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(checkNetwork), name: NSNotification.Name(rawValue: NETWORKAVAILBLE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkNetwork), name: NSNotification.Name(rawValue: NETWORKNOTREACHABLE), object: nil)
        self.tableView.delegate = self
        self.tableView.dataSource  = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight =  self.view.frame.height
        self.presenter = ServicePresenter()
        self.presenter?.getAllCategories()
        self.presenter?.getAllPromotions()
        self.selectionDelegate = self
        self.promotionDelegate = self

    }


    
    var presenter: ServicePresenter? {
        didSet {
            presenter?.category.observe {
                [unowned self] (results) in
                self.categoryList = results.count > 0 ? results : []
                 self.tableView.reloadData()
                
            }
            
            presenter?.promotion.observe {
                [unowned self] (results) in
                self.promotionList = results.count > 0 ? results : []
                self.tableView.reloadData()
                
            }
            presenter?.errorMsg.observe { (error) in
                self.view.setNeedsLayout()
                if error.count > 0 {

                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return  170
            
        }else{
            return  self.view.frame.height - 170
        }
  
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionsCell", for: indexPath)  as! PromotionsCell
            cell.promotionsList.promotions = self.promotionList
            cell.configure(del: promotionDelegate)
            return  cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath)  as! CategoryTableViewCell
            cell.categoryList.categories = self.categoryList
            cell.configure( del: selectionDelegate)
       
            return cell
        }
 
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select a category"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as? UITableViewHeaderFooterView
        headerView?.backgroundColor = UIColor.white
        headerView?.textLabel?.textColor = #colorLiteral(red: 0.3082081974, green: 0.1841563582, blue: 0.1004526243, alpha: 1)
    }

    func itemSelected(promotion: Promotion) {
        self.promotion = promotion
        let safariVC = SFSafariViewController(url: NSURL(string: self.promotion.link)! as URL)
        if #available(iOS 10.0, *) {
            safariVC.preferredBarTintColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            safariVC.preferredControlTintColor = #colorLiteral(red: 0.3082081974, green: 0.1841563582, blue: 0.1004526243, alpha: 1)
        } else {
            safariVC.view.tintColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            safariVC.preferredControlTintColor = #colorLiteral(red: 0.3082081974, green: 0.1841563582, blue: 0.1004526243, alpha: 1)
        }
        if #available(iOS 10.0, *) {
            safariVC.preferredControlTintColor = #colorLiteral(red: 0.3082081974, green: 0.1841563582, blue: 0.1004526243, alpha: 1)
        } else {
            
        }
        self.present(safariVC, animated: true, completion: {() -> Void in
        })
    }
    
    func itemSelected(category: Category) {
        self.category = category
        self.performSegue(withIdentifier: "showService", sender: self)
    }
    
    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showService" {
            let vc = segue.destination  as! ExploreVC
            vc.category = self.category
        }
    }
    
    
    
    func startAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
        }, completion: nil)
    }
    
    @objc func checkNetwork() {
        if !Connectivity.isConnectedToInternet() {
            self.showMessage("Network connection error", type: .error)
        }
    }
}


