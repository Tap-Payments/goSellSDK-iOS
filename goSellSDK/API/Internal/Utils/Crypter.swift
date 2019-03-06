//
//  Crypter.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

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
        
        guard let data = string.data(using: .utf8, allowLossyConversion: true) else { return nil }
        
        guard let encryptedData = try? RSAUtils.encryptWithRSAPublicKey(data: data, pubkeyBase64: key) else { return nil }
        
        let resultString = encryptedData?.base64EncodedString()
        
        return resultString
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private init() {}
}
