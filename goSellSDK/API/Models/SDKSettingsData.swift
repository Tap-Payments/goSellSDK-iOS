//
//  SDKSettingsData.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// goSell SDK settings data model.
internal struct SDKSettingsData: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Payments mode.
    internal let isLiveMode: Bool
    
    /// Permissions.
    internal let permissions: Permissions
    
    /// Encryption key.
    internal let encryptionKey: String
    
    /// Unique device ID.
    // FIXME: Remove optionality here once backend is ready.
    internal let deviceID: String?
    
    /// Merchant information.
    internal let merchant: Merchant
    
    /// Internal SDK settings.
    internal let internalSettings: InternalSDKSettings
    
    /// Session token.
    internal private(set) var sessionToken: String?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case isLiveMode         = "live_mode"
        case permissions        = "permissions"
        case encryptionKey      = "encryption_key"
        case deviceID           = "device_id"
        case merchant           = "merchant"
        case internalSettings   = "sdk_settings"
        case sessionToken       = "session_token"
    }
}
