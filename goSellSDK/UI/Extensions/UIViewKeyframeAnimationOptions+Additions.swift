//
//  UIViewKeyframeAnimationOptions+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   UIKit.UIView.UIViewAnimationOptions
import struct   UIKit.UIView.UIViewKeyframeAnimationOptions

internal extension UIViewKeyframeAnimationOptions {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init(_ animationOptions: UIViewAnimationOptions) {
        
        self.init(rawValue: animationOptions.rawValue)
    }
}
