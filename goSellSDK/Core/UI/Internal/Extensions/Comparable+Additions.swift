//
//  Comparable+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal extension Comparable {
	
	// MARK: - Internal -
	// MARK: Methods
	
	func tap_isIn(_ range: ClosedRange<Self>) -> Bool {
		
		return range.contains(self)
	}
}
