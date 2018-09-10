//
//  CategoryList.swift
//  Beauty Cart
//
//  Created by George on 2018/09/07.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit


protocol CategoryItem {
    func itemSelected(category:Category)
}

class CategoryList: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var selectionDelegate : CategoryItem?
    var categories = [Category](){
        didSet{
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        screenSize = UIScreen.main.bounds
        screenWidth = self.screenSize.width
        screenHeight = self.screenSize.height
        self.delegate = self
        self.dataSource =  self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
         let item = self.categories[indexPath.row]
         cell.imgCategory.sd_setImage(with: URL(string: item.image_uri), placeholderImage: UIImage(named: ""))
         cell.lblTitle.text  = item.name
         cell.layer.masksToBounds = false
         cell.imgCategory.roundTop(radius: 3.0)
         
       
          return  cell
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

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionDelegate?.itemSelected(category: self.categories[indexPath.row])
    }
    
  

}
