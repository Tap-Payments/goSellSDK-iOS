//
//  CountryCode.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Country model.
internal struct Country {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Two-letters iso code.
    internal let isoCode: String
    
    // MARK: Methods
    
    internal init(_ isoCode: String) throws {
        
        try self.init(isoCode: isoCode)
    }
    
    internal init(isoCode: String) throws {
        
        let code = isoCode.uppercased()
        
        guard Country.allISOCodes.contains(code) else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.countryCode: code]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidCountryCode.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil)
        }
        
        self.isoCode = code
    }
    
    // MARK: - Private -
    
    private static let allISOCodes = Locale.isoRegionCodes.map { $0.uppercased() }
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
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        
        try self.init(isoCode: code)
    }
}

// MARK: - Hashable
extension Country: Hashable {
    
    internal var hashValue: Int {
        
        return self.isoCode.hashValue
    }
}
