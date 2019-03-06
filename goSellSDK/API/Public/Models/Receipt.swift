//
//  Receipt.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Receipt dispatch settings.
@objcMembers public final class Receipt: NSObject, OptionallyIdentifiableWithString, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
    public private(set) var identifier: String?
    
    /// Defines if receipt email should be sent.
    public let email: Bool
    
    /// Defines if receipt sms should be sent.
    public let sms: Bool
    
    // MARK: Methods
    
    /// Initializes `Receipt` settings model.
    ///
    /// - Parameters:
    ///   - email: Defines whether email receipt should be sent.
    ///   - sms: Defines whether sms receipt should be sent.
    public required init(email: Bool, sms: Bool) {
        
        self.email  = email
        self.sms    = sms
        
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        case email      = "email"
        case sms        = "sms"
    }
}
