//
//  CountryCode.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal final class Country {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let isoCode: String
    
    // MARK: Methods
    
    internal required init(_ code: String) throws {
        
        guard type(of: self).isoCodes.contains(code) else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.countryCode: code]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidCountryCode.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil)
        }
        
        self.isoCode = code
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private static let isoCodes = Locale.isoRegionCodes
}

// MARK: - Encodable
extension Country: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.isoCode)
    }
}

// MARK: - Decodable
extension Country: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        
        try self.init(code)
    }
}
