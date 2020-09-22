//
//  Session.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapAdditionsKitV2.TypeAlias

/// SDK session class. Use this class if you don't want to place Pay Button and make it do everything for you.
@objcMembers public final class  Session: NSObject, SessionProtocol {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// Session data source.
	public weak var dataSource: SessionDataSource?
	
	/// Session delegate.
	public weak var delegate: SessionDelegate?
	
	/// Session appearance.
	public weak var appearance: SessionAppearance?
	
	/// Defines if session can start using the provided details through the `dataSource`.
	public var canStart: Bool {
		
		return self.implementationCanStart
	}
	
	// MARK: Methods
	
	/// Calculates and returns an amount based on the details provided through the `dataSource`.
	/// You might want to call this method every time you update your `dataSource` to reflect changes in UI
	/// if you are not using PayButton provided by the SDK.
	///
	/// - Returns: Amount suggested to display to the customer or `nil` in the following cases:
	/// 	1. Session cannot start with the provided details.
	/// 	2. You are in card saving mode.
	public func calculateDisplayedAmount() -> NSDecimalNumber? {
		
		return self.implementationCalculateDisplayedAmount()
	}
	
	/// Initiates the session.
	///
	/// - Returns: Returns boolean value which determines whether all conditions are met to start the sesssion.
	@discardableResult public func start() -> Bool {
		
		return self.implementationStart()
	}
    
    
    /// Initiates the session.
    ///
    /// - Returns: Returns boolean value which determines whether all conditions are met to start the sesssion.
    @discardableResult public func startApplePay() -> Bool {
        
        return self.implementationApplyPayStart()
    }
	
    /// Initiates the session.
    ///
    /// - Returns: Returns boolean value which determines whether all conditions are met to start the sesssion.
    @discardableResult public func startAppleUIPay() -> Bool {
        
        return self.implementationApplyPayStart(ui:true)
    }
    
    
	/// Stops the receiving session dismissing all the user interface. Treats this action as if session was cancelled by the user.
	/// Use this method when your app wants to interrupt payment process (f.ex. when you perform a deep link and need to show your UI).
	///
	/// - Parameter completion: Completion closure that is called after session has stopped and all the user interface was dismissed.
	public func stop(_ completion: TypeAlias.ArgumentlessClosure? = nil) {
		
		guard Process.hasAliveInstance else {
			
			completion?()
			return
		}
		
		Process.shared.closePayment(with: .cancelled, fadeAnimation: false, force: true, completion: completion)
	}
}

// MARK: - InternalSessionImplementation
extension Session: InternalSessionImplementation {}
