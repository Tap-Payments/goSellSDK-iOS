//
//  Process.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKit.TypeAlias

internal final class Process {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal private(set) var transactionMode:	TransactionMode	= .default
	internal private(set) var appearance:		AppearanceMode	= .fullscreen
	
	internal private(set) var externalSession: SessionProtocol?
	
	internal var wrappedImplementation: Wrapped {
		
		if let existing = self.wrapped {
			
			if let _: Process.Implementation<PaymentClass> = existing.implementation(), (self.transactionMode == .purchase || self.transactionMode == .authorizeCapture) {
				
				return existing
			}
			else if let _: Process.Implementation<CardSavingClass> = existing.implementation(), self.transactionMode == .cardSaving {
				
				return existing
			}
		}
		
		switch self.transactionMode {
			
		case .purchase, .authorizeCapture:
			
			let impl = Implementation<PaymentClass>.with(process: self, mode: PaymentClass.self)
			let w = Wrapped(impl)
			
			self.wrapped = w
			
			return w
			
		case .cardSaving:
			
			let impl = Implementation<CardSavingClass>.with(process: self, mode: CardSavingClass.self)
			let w = Wrapped(impl)
			
			self.wrapped = w
			
			return w
		}
	}
	
	// MARK: Methods
	
	internal static func paymentClosed() {
		
		KnownStaticallyDestroyableTypes.destroyAllInstances()
	}
	
	@discardableResult internal func start(_ session: SessionProtocol) -> Bool {
		
		self.transactionMode	= session.dataSource?.mode ?? .default
		self.appearance			= self.obtainAppearanceMode(from: session)
		
		let result = self.dataManagerInterface.loadPaymentOptions(for: session)
		
		if result {
			
			self.externalSession = session
		}
		
		return result
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	private static var storage: Process?
	
	private var wrapped: Wrapped?
	
	// MARK: Methods
	
	private init() {
		
		KnownStaticallyDestroyableTypes.add(Process.self)
	}
	
	private func obtainAppearanceMode(from session: SessionProtocol) -> AppearanceMode {
		
		let publicAppearance = session.dataSource?.appearance ?? .default
		let transactionMode = session.dataSource?.mode ?? .default
		
		let result = AppearanceMode(publicAppearance: publicAppearance, transactionMode: transactionMode)
		
		return result
	}
}

// MARK: - ImmediatelyDestroyable
extension Process: ImmediatelyDestroyable {
	
	internal static var hasAliveInstance: Bool {
		
		return self.storage != nil
	}
	
	internal static func destroyInstance() {
		
		self.storage = nil
	}
}

// MARK: - Singleton
extension Process: Singleton {
	
	internal static var shared: Process {
		
		if let nonnullStorage = self.storage {
			
			return nonnullStorage
		}
		
		let instance = Process()
		self.storage = instance
		
		return instance
	}
}
