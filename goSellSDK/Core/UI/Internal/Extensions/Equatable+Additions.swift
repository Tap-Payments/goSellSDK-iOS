//
//  Equatable+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal extension Equatable {
	
	// MARK: - Internal -
	// MARK: Methods
	
	func tap_isIn(_ array: [Self]) -> Bool {
		
		return array.contains(self)
	}
}
