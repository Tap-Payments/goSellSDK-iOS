//
//  AuthorizeActionResponse.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Authorize action response class.
@objcMembers public final class AuthorizeActionResponse: AuthorizeAction {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Authorize action status.
    public private(set) var status: AuthorizeActionStatus = .failed
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case type   = "type"
        case time   = "time"
        case status = "status"
    }
}
