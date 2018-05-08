//
//  UIColor+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIColor.UIColor

internal extension UIColor {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func hex(_ value: String) -> UIColor {
    
        guard let color = UIColor(hex: value) else {
            
            fatalError("\(value) is invalid color hex string.")
        }
        
        return color
    }
}
