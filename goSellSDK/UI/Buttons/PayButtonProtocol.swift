//
//  PayButton.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import class UIKit.UIView.UIView

public protocol PayButtonProtocol: ClassProtocol where Self: UIView {
    
    var isEnabled: Bool { get set }
    var state: PayButtonState { get }
    
    var amount: Decimal { get set }
    var currency: String { get set }
    
    var delegate: PayButtonDelegate? { get set }
}

internal extension PayButtonProtocol {
    
    var view: UIView {
        
        return self
    }
}
