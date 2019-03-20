//
//  TapButtonDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol TapButtonDelegate: ClassProtocol {
    
    // MARK: Properties
    
    var canBeHighlighted: Bool { get }
    
    // MARK: Methods
    
    func buttonTouchUpInside()
    
    func securityButtonTouchUpInside()
	
	func disabledButtonTouchUpInside()
}
