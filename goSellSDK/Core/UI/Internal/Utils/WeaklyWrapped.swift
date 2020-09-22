//
//  WeaklyWrapped.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol	TapAdditionsKitV2.ClassProtocol

internal class WeaklyWrapped<Object: NSObjectProtocol> {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal private(set) weak var object: Object?
	
	// MARK: Methods
	
	internal init(_ object: Object) {
		
		self.object = object
	}
}
