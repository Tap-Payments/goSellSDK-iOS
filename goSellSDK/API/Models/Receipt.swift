//
//  Receipt.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct Receipt: Identifiable, Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal private(set) var identifier: String?
    
    /// Defines if receipt email should be sent.
    internal let email: Bool
    
    /// Defines if receipt sms should be sent.
    internal let sms: Bool
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        case email      = "email"
        case sms        = "sms"
    }
}
