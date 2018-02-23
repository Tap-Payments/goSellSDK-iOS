//
//  Crypter.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class goSellCrypto.goSellCrypto

/// Crypter helper class.
internal class Crypter {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Encrypts the given string using the given key.
    ///
    /// - Parameters:
    ///   - string: String to encrypt.
    ///   - key: Key to encrypt with.
    /// - Returns: String if the encryption succeed.
    internal static func encrypt(_ string: String, using key: String) -> String? {
        
        return goSellCrypto.encrypt(string, using: key)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private init() {}
}
