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


class ExploreVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate, EmptyDataSetSource, EmptyDataSetDelegate {
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var serviceList = [Service]()
    var filteredService = [Service]()
    var category: Category!
    var activityIndicator = UIActivityIndicatorView()
     var searchController = UISearchController()
     private let refreshControl = UIRefreshControl()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnMenu: UIButton!
    var service:Service!
    @IBOutlet weak var btnAdd: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshService), name: NSNotification.Name(rawValue: RELOAD), object: nil)
        self.collectionView.emptyDataSetSource  = self
        self.collectionView.emptyDataSetDelegate  = self
        self.collectionView.delegate  = self
        screenSize = UIScreen.main.bounds
        screenWidth = self.screenSize.width
        screenHeight = self.screenSize.height
         self.activityIndicator.startAnimating()
         self.presenter = ServicePresenter()
         self.presenter?.getAllService(categoryId: self.category._id)
         self.addRefreshControll()
         self.collectionView.emptyDataSetView { (view) in
            view.isScrollAllowed(true)
         }
         self.setupView()
    }

  
    var presenter: ServicePresenter? {
        didSet {
            presenter?.service.observe {
                [unowned self] (results) in
                self.serviceList = results.count > 0 ? results : []
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
                 self.refreshControl.endRefreshing()
                
            }
            presenter?.errorMsg.observe { (error) in
                self.view.setNeedsLayout()
                if error.count > 0 {
                     self.activityIndicator.stopAnimating()
                     self.refreshControl.endRefreshing()
                }
              
            }
        }
    }
    
    
    
    override  func viewWillAppear(_ animated: Bool) {
       self.title  = self.category.name
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
       self.searchController.dismiss(animated: false, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @objc func refreshService() {
         self.presenter?.getAllService(categoryId: self.category._id)
    }
    
    
    @IBAction func btnAddTapped(_ sender: Any) {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let   vc = storyboard.instantiateViewController(withIdentifier: "AddServiceVC")
            self.present(vc, animated: true, completion: nil)
    }
    
    func addRefreshControll() {
        self.refreshControl.backgroundColor = UIColor.black
        refreshControl.tintColor = UIColor.white
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            self.collectionView.addSubview(refreshControl)
        }
        let attributes: NSAttributedString =
            NSAttributedString(string: "Updating", attributes:
                [NSAttributedStringKey.foregroundColor : UIColor.white])
        refreshControl.attributedTitle = attributes
        refreshControl.addTarget(self, action: #selector(self.refreshService), for: .valueChanged)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchController.isActive {
           return self.filteredService.count
        }
        return self.serviceList.count
    }
    
    
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if self.searchController.isActive {
           self.service  = self.filteredService[indexPath.row]
         }else{
             self.service  = self.serviceList[indexPath.row]
        }
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!  ExploreCell
        cell.layer.masksToBounds = false
        if self.searchController.isActive {
            self.service = self.filteredService[indexPath.row]
        }else{
            self.service = self.serviceList[indexPath.row]
        }
        cell.lblTime.text  = self.service .available_time
        cell.lblPrice.text  = self.service .price.convertCurrency()
        cell.lblLocation.text  = self.service .address
        cell.imgService.sd_setImage(with: URL(string: self.service .image_uri), placeholderImage: UIImage(named: "coming_soon"))
        cell.imgService.roundTop(radius: 3.0)
        cell.lblName.text  = self.service.name
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.screenWidth - 16 , height: 245)
    }
    



    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [
            NSAttributedStringKey.font:  UIFont.boldSystemFont(ofSize: 18.0)
        ]
        return  NSAttributedString(string:  "Explore \(self.category.name!)", attributes: attributes )
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [
            NSAttributedStringKey.font:  UIFont.systemFont(ofSize: 14)
        ]
        return  NSAttributedString(string:  "No \(self.category.name!) found in your area at the moment.", attributes: attributes )
        
     
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    private func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        //self.searchController.isActive = false
     
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      self.presenter?.getAllService(categoryId: self.category._id)
        self.collectionView.reloadData()
        self.searchController.searchBar.text = ""
         self.searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.text = ""
        self.searchController.searchBar.resignFirstResponder()
        self.searchController.isActive = false
        self.searchController.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredService = self.serviceList.filter({ (service : Service) -> Bool in
            let searchName: NSString = "\(service.name.lowercased())" as NSString
            let range = searchName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(self.filteredService.count == 0){
            self.searchController.isActive = false
        } else {
            self.searchController.isActive = true
            
        }
        
        self.collectionView?.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.layoutSubviews()
    }
    

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            self.searchController.isActive = false
            self.searchController.searchBar.resignFirstResponder()
            self.searchController.searchBar.text = ""

               self.presenter?.getAllService(categoryId: self.category._id)
        }
    }
    func setupView() {
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = self.searchController
            let top = self.collectionView.adjustedContentInset.top
            let y = self.refreshControl.frame.maxY + top
            self.collectionView.setContentOffset(CGPoint(x: 0, y: -y), animated:true)
            
            
        } else {
            // Fallback on earlier versions
        }
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.delegate  = self
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        self.searchController.searchBar.tintColor  = #colorLiteral(red: 0.3082081974, green: 0.1841563582, blue: 0.1004526243, alpha: 1)
        definesPresentationContext = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = self.searchController
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    


}
