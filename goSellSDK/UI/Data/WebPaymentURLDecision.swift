//
//  WebPaymentURLDecision.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Web Payment URL decision.
internal struct WebPaymentURLDecision {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Defines if URL should be loaded.
    internal let shouldLoad: Bool
    
    /// Defines if web payment screen should be closed.
    internal let shouldCloseWebPaymentScreen: Bool
}
