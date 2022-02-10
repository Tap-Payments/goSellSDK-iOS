//
//  Crypter.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Crypter helper class.
import SwiftyRSA
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
        UIPasteboard.general.string = ""
        
        guard let publicKey = try? PublicKey(pemEncoded: key) else { return nil }
        guard let clear = try? ClearMessage(string: string, using: .utf8) else { return nil }
        
        var resultString = ""
        
        while true {
            guard let toEncryptData = try? clear.encrypted(with: publicKey, padding: .PKCS1) else { return nil }
            resultString = toEncryptData.base64String
            if !resultString.hasSuffix("AA==") {
                break
            }
            //UIPasteboard.general.string = "\(UIPasteboard.general.string ?? "")\nFAILED TRYING AGAIN"
        }
        
        //UIPasteboard.general.string = "\(UIPasteboard.general.string ?? "")\nDATA : \(string)\n:KEY : \(key)\nENC : \(resultString)"
        return resultString
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    //@available(*, unavailable) private init() { }
}
