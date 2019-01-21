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
		
		return PaymentDataManager.shared.canStart(self)
	}
	
	internal func implementationStart() -> Bool {
		
		guard self.implementationCanStart else { return false }
		
		DispatchQueue.main.async {
			
			UIResponder.tap_resign()
		}
		
		return PaymentDataManager.shared.start(self)
	}
	
	internal func implementationCalculateDisplayedAmount() -> NSDecimalNumber? {
		
		guard self.implementationCanStart else { return nil }
		return PaymentDataManager.shared.calculateDisplayedAmount(for: self)
	}
}
