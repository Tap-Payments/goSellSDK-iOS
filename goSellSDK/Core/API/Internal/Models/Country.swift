//
//  CountryCode.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Country model.
internal struct Country {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Two-letters iso code.
    internal let isoCode: String
    
    internal static func == (lhs: Country, rhs: Country) -> Bool {
        
        return lhs.isoCode.lowercased() == rhs.isoCode.lowercased()
    }
    
    // MARK: Methods
    
    internal init(isoCode: String) throws {
        
        let code = isoCode.uppercased()
        
        guard Country.allISOCodes.contains(code) else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.countryCode: code]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidCountryCode.rawValue, userInfo: userInfo)
			throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
        }
        
        self.isoCode = code
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init(_ isoCode: String) throws {
        
        try self.init(isoCode: isoCode)
    }
    
    // MARK: - Private -
    
    private static let allISOCodes = Locale.isoRegionCodes.map { $0.uppercased() }
}

// MARK: - Hashable
extension Country: Hashable {
    
    internal var hashValue: Int {
        
        return self.isoCode.hashValue
    }
}

// MARK: - Encodable
extension Country: Encodable {
    
    internal func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.isoCode)
    }
}

// MARK: - Decodable
extension Country: Decodable {
    
    internal init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        
        try self.init(isoCode: code)
    }
}
