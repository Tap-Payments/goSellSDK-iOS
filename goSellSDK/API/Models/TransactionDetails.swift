//
//  TransactionDetails.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct TransactionDetails: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Transaction creation date.
    internal let creationDate: Date
    
    /// Transaction time zone.
    internal let timeZone: String
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case creationDate   = "created"
        case timeZone       = "timezone"
    }
}
