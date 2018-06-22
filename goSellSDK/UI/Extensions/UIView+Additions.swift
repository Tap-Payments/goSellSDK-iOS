//
//  UIView+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   TapAdditionsKit.TypeAlias
import class    UIKit.UIView.UIView

internal extension UIView {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func resignResponder(_ completion: @escaping TypeAlias.ArgumentlessClosure) {
        
        if let responder = self.firstResponder {
            
            responder.resignFirstResponder(completion)
        }
        else {
            
            completion()
        }
    }
}
