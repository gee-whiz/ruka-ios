//
//  ExploreVC.swift
//  Ruka
//
//  Created by George on 2018/04/04.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import SDWebImage
import MaterialComponents.MaterialBottomAppBar


private let reuseIdentifier = "ExploreCell"


class ExploreVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, EmptyDataSetSource, EmptyDataSetDelegate {
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var serviceList = [Service]()
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnMenu: UIButton!
    var service:Service!
    @IBOutlet weak var btnAdd: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
        self.collectionView.emptyDataSetSource  = self
        self.collectionView.emptyDataSetDelegate  = self
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.collectionView.delegate  = self
        screenSize = UIScreen.main.bounds
        screenWidth = self.screenSize.width
        screenHeight = self.screenSize.height
         self.activityIndicator.startAnimating()
         self.presenter = ServicePresenter()
         self.presenter?.getAllService()
        //self.setupBootomBar()
    }

  
    var presenter: ServicePresenter? {
        didSet {
            presenter?.service.observe {
                [unowned self] (results) in
                self.serviceList = results.count > 0 ? results : []
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
                
            }
            presenter?.errorMsg.observe { (error) in
                self.view.setNeedsLayout()
                if error.count > 0 {
                     self.activityIndicator.stopAnimating()
                }
              
            }
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    @IBAction func btnAddTapped(_ sender: Any) {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let   vc = storyboard.instantiateViewController(withIdentifier: "AddServiceVC")
            self.revealViewController().setFront(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.serviceList.count
    }
    
    
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         self.service  = self.serviceList[indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!  ExploreCell
        cell.layer.masksToBounds = false
        
        let item = self.serviceList[indexPath.row]
        cell.lblTime.text  = item.available_time
        cell.lblPrice.text  = item.price
        cell.lblLocation.text  = item.address
        cell.imgService.sd_setImage(with: URL(string: item.image_uri), placeholderImage: UIImage(named: "coming_soon"))
        cell.lblName.text  = item.name
        debugPrint(item.address)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.screenWidth - 16 , height: 245)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return  #imageLiteral(resourceName: "barber_33118_640")
    }


    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [
            NSAttributedStringKey.font:  UIFont.boldSystemFont(ofSize: 18.0)
        ]
        return  NSAttributedString(string:  "Explore Stylists", attributes: attributes )
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [
            NSAttributedStringKey.font:  UIFont.systemFont(ofSize: 14)
        ]
        return  NSAttributedString(string:  "No Stylists found in your area at the moment", attributes: attributes )
        
     
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return UIColor.init(white: 0.95, alpha: 1)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination  as! ServiceDetail
            vc.service = self.service
        }
        
        
    }
    
    
    func setupBootomBar() {
        let frame = CGRect(x: 0, y: self.view.frame.height - 100, width: self.view.frame.width, height: 50.0)
        let bottomBarView = MDCBottomAppBarView(frame: frame)
        view.addSubview(bottomBarView)
        
  
        
        // Set the image on the floating button.
        let addImage = UIImage(named:"ic_add_white")
        bottomBarView.floatingButton.setImage(addImage, for: .normal)
        bottomBarView.floatingButton.backgroundColor  = #colorLiteral(red: 0.3082081974, green: 0.1841563582, blue: 0.1004526243, alpha: 1)
      

    }

}
