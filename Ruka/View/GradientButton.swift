//
//  GradientButton.swift
//  Ruka
//
//  Created by George on 2018/03/17.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import Foundation

import UIKit


@IBDesignable
class GradientButton: UIButton {
    
    
    override func awakeFromNib() {
        setupView()
    }
    
    @IBInspectable  var borderColor: UIColor = #colorLiteral(red: 0, green: 0.4235294118, blue: 0.7764705882, alpha: 1){
        
        didSet {
            self.setNeedsLayout()
        }
        
    }
    
    @IBInspectable  var backColor: UIColor = #colorLiteral(red: 0, green: 0.4235294118, blue: 0.7764705882, alpha: 1){
        
        didSet {
            self.setNeedsLayout()
        }
        
    }
    
    @IBInspectable  var cornerRadius: CGFloat = 5.0 {
        
        didSet {
            self.setNeedsLayout()
        }
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func  setupView() {
        
        self.backgroundColor = backColor
        self.layer.borderWidth = 1.0
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
    }
    
}
