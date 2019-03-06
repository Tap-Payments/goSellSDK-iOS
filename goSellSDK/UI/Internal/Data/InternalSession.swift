//
//  InternalSession.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Internal session class.
internal class InternalSession: SessionProtocol, InternalSessionImplementation {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal weak var dataSource: SessionDataSource?
	
	internal weak var delegate: SessionDelegate?
	
	internal weak var appearance: SessionAppearance?
	
	// MARK: Methods
	
	internal init(_ session: SessionProtocol) {
		
		self.session = session
	}
	
	@discardableResult internal func start() -> Bool {
		
		return self.implementationStart()
	}
	
	internal func calculateDisplayedAmount() -> NSDecimalNumber? {
		
		return self.implementationCalculateDisplayedAmount()
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	private unowned let session: SessionProtocol
	
	private var canStart: Bool {
		
		return self.implementationCanStart
	}
}

// MARK: - InternalSessionProtocol
extension InternalSession: InternalSessionProtocol {
	
	internal var externalSession: SessionProtocol {
		
		return self.session
	}
}
