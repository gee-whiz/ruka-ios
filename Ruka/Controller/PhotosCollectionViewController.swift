//
//  PhotosCollectionViewController.swift
//  Ruka
//
//  Created by George on 2018/04/08.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import BSImagePicker
import Photos
import PhotosUI


private let reuseIdentifier = "PhotoCell"

class PhotosCollectionViewController: UIViewController
, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate, EmptyDataSetSource, EmptyDataSetDelegate {
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var activityIndicator = UIActivityIndicatorView()
    var images = [UIImage]()
    var data = [DynamicField]()
    var latitude: String!
    var longitude: String!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate  = self
        screenSize = UIScreen.main.bounds
        screenWidth = self.screenSize.width
        screenHeight = self.screenSize.height
        self.collectionView.emptyDataSetSource = self
        self.collectionView.emptyDataSetDelegate = self
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
        self.presenter = ServicePresenter()
        self.collectionView.emptyDataSetView { (view) in
            view.isScrollAllowed(true)
        }
        debugPrint(self.longitude)
    
    }


    
    
    var presenter: ServicePresenter? {
        didSet {
            presenter?.addServiceMsg.observe { (msg) in
                self.view.setNeedsLayout()
                if msg.count > 0 {
                    self.activityIndicator.stopAnimating()
                    self.showMessage(msg, type: .success)
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            presenter?.errorMsg.observe { (error) in
                self.view.setNeedsLayout()
                if error.count > 0 {
                    self.activityIndicator.stopAnimating()
                }
                
            }
        presenter?.imageUrl.observe({ (url) in
            if url.count > 0 {
                self.addService(imageUrl: url)
            }
            
        })
        }
        
       
    }
    // MARK: UICollectionViewDataSource

  func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCell
        cell.layer.masksToBounds = false
        let item = images[indexPath.row]
        cell.imgPhoto.layer.cornerRadius = 5.0
        cell.imgPhoto.image  = item
    
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfClumns: CGFloat = 3
        if UIScreen.main.bounds.width  > 320 {
            numberOfClumns = 3
        }
        let spaceBetweenCells:CGFloat = 8
        let padding:CGFloat = 40
        let cellDimension = ((collectionView.bounds.width - padding) - (numberOfClumns - 1) * spaceBetweenCells) / numberOfClumns
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    @IBAction func btnAddTapped(_ sender: Any) {
        let vc = BSImagePickerViewController()
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            let image = self.getAssetThumbnail(asset: asset)
            
            DispatchQueue.main.async {
                self.images.append(image)
                 self.collectionView.reloadData()
            }
           
        }, cancel: { (assets: [PHAsset]) -> Void in
        }, finish: { (assets: [PHAsset]) -> Void in
            
            for asset in assets {
                let image = self.getAssetThumbnail(asset: asset)
                DispatchQueue.main.async {
                    self.images.append(image)
                    self.collectionView.reloadData()
                }
            }
        
  
        }, completion: nil)
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize:  PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return  #imageLiteral(resourceName: "empty_image")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [
            NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 18.0)
        ]
        return  NSAttributedString(string:  "Add Photos", attributes: attributes )
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [
            NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 14)
        ]
        return  NSAttributedString(string:  "Make your Listing more inviting.Tap Add Photos Button.You can always add more photos after you complete your listing", attributes: attributes )
        
        
    }
    
    @IBAction func btnSkipTapped(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
          //self.addService(imageUrl: "")
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        self.activityIndicator.startAnimating()
        if self.images.count > 0 {
            let image = self.images[0].jpegData(compressionQuality: 0.5)! as NSData
            self.presenter?.uploadImage(imageData: image as Data)
        }else{
            self.addService(imageUrl: "")
        }
    }
    
    func addService(imageUrl: String) {       
        self.presenter?.addService(name: self.data[0].value,category: self.data[1].value, price: self.data[3].value, address: self.data[4].value, latitude: Double(self.latitude)!, longitude: Double(self.longitude)! , phone: self.data[6].value, description: self.data[7].value, email: self.data[5].value, image_uri: imageUrl, available_time: self.data[2].value)
    }
    
}
