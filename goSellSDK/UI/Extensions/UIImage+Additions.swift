//
//  UIImage+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGSize
import class    UIKit.UIImage.UIImage
import enum     UIKit.UIView.UIViewContentMode

internal extension UIImage {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func named(_ name: String, in bundle: Bundle) -> UIImage? {
        
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    internal func bestContentMode(toFit size: CGSize) -> UIViewContentMode {
    
        let widthFits       = self.size.width <= size.width
        let heightFits      = self.size.height <= size.height
        let proportion      = self.size.width / self.size.height
        let frameProportion = size.width / size.height
        
        switch (widthFits, heightFits) {
            
        case (true, true):
            
            return .center
            
        case (true, false), (false, true):
            
            return .scaleAspectFit
            
        case (false, false):
            
            return proportion == frameProportion ? .scaleToFill : .scaleAspectFit

        }        
    }
}
