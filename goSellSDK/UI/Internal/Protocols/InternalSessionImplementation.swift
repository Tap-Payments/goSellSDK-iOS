//
//  InternalSessionImplementation.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIResponder.UIResponder

internal protocol InternalSessionImplementation: SessionProtocol {}

internal extension InternalSessionImplementation {
	
	internal var implementationCanStart: Bool {
		
		return Process.Validation.canStart(using: self)
	}
	
	internal func implementationStart() -> Bool {
		
		guard self.implementationCanStart else { return false }
		
		DispatchQueue.main.async {
			
			UIResponder.tap_resign()
		}
		
		return Process.shared.start(self)
	}
	
	internal func implementationCalculateDisplayedAmount() -> NSDecimalNumber? {
		
		guard self.implementationCanStart else { return nil }
		return Process.NonGenericAmountCalculator.totalAmount(for: self)
	}
}
