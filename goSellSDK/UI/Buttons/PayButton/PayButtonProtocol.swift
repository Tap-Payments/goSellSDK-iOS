//
//  PayButton.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import class UIKit.UIView.UIView

/// Pay Button Protocol.
public protocol PayButtonProtocol: ClassProtocol {
    
    /// Controls enabled state of the receiver. Final decision is taken by internal logic.
    var isEnabled: Bool { get set }
}

internal extension PayButtonProtocol where Self: UIView {
    
    var view: UIView {
        
        return self
    }
}
