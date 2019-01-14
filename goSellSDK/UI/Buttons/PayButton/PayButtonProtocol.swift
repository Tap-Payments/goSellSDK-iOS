//
//  PayButton.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UIView.UIView

/// Pay Button Protocol.
@objc public protocol PayButtonProtocol: NSObjectProtocol {
    
    /// Controls enabled state of the receiver. Final decision is taken by internal logic.
    var isEnabled: Bool { get set }
}

internal extension PayButtonProtocol where Self: UIView {
    
    var view: UIView {
        
        return self
    }
}
