//
//  UIView+Extensions.swift
//  WeatherMyApp
//
//  Created by Kadirhan Keles on 14.08.2023.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
