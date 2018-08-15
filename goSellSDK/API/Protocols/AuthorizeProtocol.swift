//
//  AuthorizeProtocol.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal protocol AuthorizeProtocol: ChargeProtocol {
    
    /// Authorize action.
    var authorizeAction: AuthorizeActionResponse { get }
}
