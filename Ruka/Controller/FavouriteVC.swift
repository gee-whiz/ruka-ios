//
//  FavouriteVC.swift
//  Ruka
//
//  Created by George on 2018/04/05.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
private let reuseIdentifier = "ExploreCell"

class FavouriteVC: UIViewController,EmptyDataSetSource, EmptyDataSetDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
   var serviceList = [Service]()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnMenu: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate  = self
        screenSize = UIScreen.main.bounds
        screenWidth = self.screenSize.width
        screenHeight = self.screenSize.height
   
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    @IBAction func btnAddTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let   vc = storyboard.instantiateViewController(withIdentifier: "AddServiceVC")
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.serviceList.count
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!  ExploreCell
        cell.layer.masksToBounds = false
     
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.screenWidth - 16 , height: 245)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return  #imageLiteral(resourceName: "add_favorite")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [
            NSAttributedStringKey.font:  UIFont.boldSystemFont(ofSize: 18.0)
        ]
        return  NSAttributedString(string:  "Favourites", attributes: attributes )
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [
            NSAttributedStringKey.font:  UIFont.systemFont(ofSize: 14)
        ]
        return  NSAttributedString(string:  "You can tap the heart on the Home screen to start saving your favourites Stylists.", attributes: attributes )
        
        
    }
    
 
    



}
