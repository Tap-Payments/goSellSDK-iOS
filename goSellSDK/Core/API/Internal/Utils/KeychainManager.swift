//
//  KeychainManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class TapKeychain.Keychain

internal class KeychainManager {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static var deviceID: String? {
        
        get {
            
            let key = self.deviceIDKey(for: GoSellSDK.mode)
            return Keychain.read(for: key)
        }
        set {
            
            let key = self.deviceIDKey(for: GoSellSDK.mode)
            Keychain.write(newValue, for: key)
        }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let deviceIDKey = Constants.keyPrefix + "device_id"
        
        private static let keyPrefix = "goSellSDK."
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Methods
    
    //@available(*, unavailable) private init() { }
    
    private static func deviceIDKey(for mode: SDKMode) -> String {
        
        return Constants.deviceIDKey + "_\(mode)"
    }
}
