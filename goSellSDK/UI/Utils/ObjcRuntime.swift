//
//  ObjcRuntime.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal func tap_objc_getAssociatedObject<T>(_ object: Any!, _ key: UnsafeRawPointer!, _ defaultValue: T) -> T {
	
	guard let value = objc_getAssociatedObject(object, key) as? T else {
		
		return defaultValue
	}
	
	return value
}

internal func tap_objc_getAssociatedObject<T>(_ object: Any!, _ key: UnsafeRawPointer!) -> T? {
	
	return objc_getAssociatedObject(object, key) as? T
}
