//
//  ErrorAction.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Error action.
internal struct ErrorAction: OptionSet {
    
    // MARK: - Internal -
	// MARK: Properties
    
    internal let rawValue: Int
    
    internal static let retry           = ErrorAction(rawValue: 1     )
    internal static let alert           = ErrorAction(rawValue: 1 << 1)
    internal static let closePayment    = ErrorAction(rawValue: 1 << 2)
}
