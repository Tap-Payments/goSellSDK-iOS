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
    internal let isLiveMode: Bool = false
    
    /// Permissions.
    internal let permissions: Permissions = .none
    
    /// Encryption key.
    // FIXME: Remove optionality here.
    internal private(set) var encryptionKey: String? = .empty
    
    /// Merchant information.
    internal let merchant: Merchant
    
    /// Internal SDK settings.
    internal let internalSettings: InternalSDKSettings
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case isLiveMode = "livemode"
        case permissions = "permissions"
        case encryptionKey = "encryption_key"
        case merchant = "merchant"
        case internalSettings = "sdk_settings"
    }
}
