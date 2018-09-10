//
//  PromotionsList.swift
//  Beauty Cart
//
//  Created by George on 2018/09/07.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit


protocol PromotionItem {
    func itemSelected(promotion:Promotion)
}

class PromotionsList: UICollectionView, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var selectionDelegate : PromotionItem?
    var promotions = [Promotion](){
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
        self.startTimer()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.promotions.count
    }
    
 

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoCollectionViewCell", for: indexPath) as! PromoCollectionViewCell
        let item = self.promotions[indexPath.row]
        cell.imgPromo.sd_setImage(with: URL(string: item.image_uri), placeholderImage: UIImage(named: ""))
        cell.layer.masksToBounds = false
        return  cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionDelegate?.itemSelected(promotion: self.promotions[indexPath.row])
    }
    
  
    func startTimer() {
      Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {
            for cell in self.visibleCells {
                let indexPath: IndexPath? = self.indexPath(for: cell)
                if ((indexPath?.row)!  <  self.promotions.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    self.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    self.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
            }
    }
    
}
