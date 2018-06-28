//
//  UIViewAnimationOptions+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum     UIKit.UIView.UIViewAnimationCurve
import struct   UIKit.UIView.UIViewAnimationOptions

internal extension UIViewAnimationOptions {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init(_ curve: UIViewAnimationCurve) {
        
        switch curve {
            
        case .easeIn:       self = .curveEaseIn
        case .easeOut:      self = .curveEaseOut
        case .easeInOut:    self = .curveEaseInOut
        case .linear:       self = .curveLinear

        }
    }
}
