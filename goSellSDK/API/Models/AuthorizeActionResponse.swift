//
//  AuthorizeActionResponse.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal final class AuthorizeActionResponse: AuthorizeAction {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal private(set) var status: AuthorizeActionStatus = .failed
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case type   = "type"
        case time   = "time"
        case status = "status"
    }
}
