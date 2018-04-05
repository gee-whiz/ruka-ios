//
//  CircleImage.swift
//  Ruka
//
//  Created by George on 2018/04/04.
//  Copyright © 2018 george kapoya. All rights reserved.
//


import Foundation
import UIKit

@IBDesignable
class CircleImage: UIImageView {
    
    
    override func awakeFromNib() {
        setupView()
    }
    
    
    
    func setupView() {
        
        self.layer.cornerRadius  = self.frame.width / 2
        self.clipsToBounds  = true
        
    }
    
    
    override  func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}
