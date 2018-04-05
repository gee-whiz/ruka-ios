//
//  Extension.swift
//  Ruka
//
//  Created by George on 2018/03/14.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import Foundation


extension UITextField {
    /// Moves the caret to the correct position by removing the trailing whitespace
    func fixCaretPosition() {
        // Moving the caret to the correct position by removing the trailing whitespace
        // http://stackoverflow.com/questions/14220187/uitextfield-has-trailing-whitespace-after-securetextentry-toggle
        
        let beginning = beginningOfDocument
        selectedTextRange = textRange(from: beginning, to: beginning)
        let end = endOfDocument
        selectedTextRange = textRange(from: end, to: end)
    }
}

extension UIActivityIndicatorView {
    convenience init(activityIndicatorStyle: UIActivityIndicatorViewStyle, color: UIColor, placeInTheCenterOf parentView: UIView) {
        self.init(activityIndicatorStyle: activityIndicatorStyle)
        center = parentView.center
        self.color = #colorLiteral(red: 0.9537598491, green: 0.2608756125, blue: 0.4666399956, alpha: 1)
        parentView.addSubview(self)
    }
}
