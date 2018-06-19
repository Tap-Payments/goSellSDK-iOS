//
//  Receipt.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Receipt dispatch settings.
@objcMembers public final class Receipt: NSObject, Identifiable, Codable {
    
    // MARK: - Public -
    // MARK: Properties
    
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
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal private(set) var identifier: String?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        case email      = "email"
        case sms        = "sms"
    }
}
