//
//  SDKSettingsData.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// goSell SDK settings data model.
internal class SDKSettingsData: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Payments mode.
    internal private(set) var isLiveMode: Bool = false
    
    /// Permissions.
    internal private(set) var permissions: Permissions = .none
    
    /// Defines if application is verified.
    internal private(set) var isApplicationVerified: Bool = false
    
    /// Encryption key.
    internal private(set) var encryptionKey: String = .empty
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case isLiveMode = "livemode"
        case permissions = "permissions"
        case isApplicationVerified = "verified_application"
        case encryptionKey = "encryption_key"
    }
}
