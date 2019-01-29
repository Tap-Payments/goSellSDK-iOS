//
//  WrappedAndTypeErased.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal final class WrappedAndTypeErased {
	
	internal func unwrapped<T>() -> T? {
		
		return self.erasedTypeObject as? T
	}
	
	internal init<T>(_ object: T) {
		
		self.erasedTypeObject = object
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	private let erasedTypeObject: Any
}
