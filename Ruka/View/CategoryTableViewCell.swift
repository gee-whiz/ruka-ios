//
//  CategoryTableViewCell.swift
//  Beauty Cart
//
//  Created by George on 2018/09/07.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell,UICollectionViewDelegate{
   
    

    @IBOutlet weak var categoryList: CategoryList!
     var categoryVC: CategoryVC?
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configure(del:CategoryItem?){
        categoryList.selectionDelegate = del
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
   


    
}
