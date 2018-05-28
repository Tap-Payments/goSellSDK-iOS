//
//  KeychainManager.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapKeychain.Keychain

internal class KeychainManager {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static var deviceID: String? {
        
        get {
            
            return Keychain.read(for: Constants.deviceIDKey)
        }
        set {
            
            Keychain.write(newValue, for: Constants.deviceIDKey)
        }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let deviceIDKey = Constants.keyPrefix + "device_id"
        
        private static let keyPrefix = "goSellSDK."
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Methods
    
    @available(*, unavailable) private init() {}
}
