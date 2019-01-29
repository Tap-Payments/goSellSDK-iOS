//
//  Bool+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension Bool {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal mutating func tap_switch() {
		
		self = !self
	}
}
