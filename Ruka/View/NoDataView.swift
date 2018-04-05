//
//  NoDataView.swift
//  Ruka
//
//  Created by George on 2018/04/05.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit

class NoDataView: UIView {

        
        @IBOutlet var view: UIView!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            loadViewFromXib()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadViewFromXib() {
            Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)
            view.frame = bounds
            addSubview(view)
        }
        
}

