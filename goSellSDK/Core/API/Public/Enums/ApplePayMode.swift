//
//  ApplePayMode.swift
//  goSellSDK
//
//  Created by Osama Rabie on 11/12/2022.
//

import Foundation
/// The action needed to be done by the apple pay button
@objc public enum ApplePayMode: Int, CaseIterable {
    
    /// Perform an actual charge using the apple pay
    @objc(charge) case charge
    
    /// Generates only the raw token we get from the Apple pay
    @objc(applePayToken) case applePayToken
    
    /// Generates a tap token for the provided apple pay token
    @objc(tapToken) case tapToken
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringRepresentation: String {
        
        switch self {
            
        case .charge:                 return "charge"
        case .applePayToken:          return "apple_token"
        case .tapToken:               return "tap_token"
            
        }
    }
    
    // MARK: Methods
    
    private init(stringRepresentation: String) {
        
        switch stringRepresentation {
            
        case ApplePayMode.charge.stringRepresentation:
            
            self = .charge
            
        case ApplePayMode.tapToken.stringRepresentation:
            
            self = .tapToken
            
        case ApplePayMode.applePayToken.stringRepresentation:
            
            self = .applePayToken
        default :
            self = .applePayToken
        }
    }
}



// MARK: - CustomStringConvertible
extension ApplePayMode: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .charge:           return "Charge"
        case .applePayToken:    return "Apple Pay Token Only"
        case .tapToken:         return "Tap Token"
            
        }
    }
}

// MARK: - Encodable
extension ApplePayMode: Encodable {
    
    /// Encodes the contents of the receiver.
    ///
    /// - Parameter encoder: Encoder.
    /// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringRepresentation)
    }
}

// MARK: - Decodable
extension ApplePayMode: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        self.init(stringRepresentation: stringValue)
    }
}
