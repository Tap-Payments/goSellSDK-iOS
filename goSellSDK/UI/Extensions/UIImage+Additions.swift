//
//  UIImage+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIImage.UIImage

internal extension UIImage {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func named(_ name: String, in bundle: Bundle) -> UIImage? {
        
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
}
