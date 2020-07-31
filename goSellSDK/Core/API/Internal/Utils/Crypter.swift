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
        
        var resultString = ""
        
        while true {
            #if swift(>=5.0)
                resultString = encryptedData.base64EncodedString()
            #else
                resultString = encryptedData?.base64EncodedString()
            #endif
            
            if !resultString.hasSuffix("AA==") {
                break
            }
            UIPasteboard.general.string = "\(UIPasteboard.general.string ?? "")\nFAILED TRYING AGAIN"
        }
        
        UIPasteboard.general.string = "\(UIPasteboard.general.string ?? "")\nDATA : \(string)\n:KEY : \(key)\nENC : \(resultString)"
        return resultString
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private init() {}
}
