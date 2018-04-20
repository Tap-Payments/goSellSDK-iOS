//
//  PayButtonUIDelegate.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol PayButtonUIDelegate: ClassProtocol {
    
    // MARK: Methods
    
    func payButtonTouchUpInside()
    
    func securityButtonTouchUpInside()
}
