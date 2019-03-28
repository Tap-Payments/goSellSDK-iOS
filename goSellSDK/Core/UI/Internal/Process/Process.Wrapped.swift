//
//  Process.ImplementationWrapper.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension Process {
	
	final class Wrapped {
	
		internal func implementation<Mode: ProcessMode>() -> Implementation<Mode>? {
			
			return self.erasedTypeImplementation as? Process.Implementation<Mode>
		}
		
		internal init<T>(_ implementation: Process.Implementation<T>) {
			
			self.erasedTypeImplementation = implementation
		}
		
		// MARK: - Private -
		// MARK: Properties
		
		private let erasedTypeImplementation: Any
	}
}
