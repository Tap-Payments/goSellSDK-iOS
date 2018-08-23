//
//  CountryCode.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Country model.
public final class Country: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Two-letters iso code.
    public let isoCode: String
    
    public override var hashValue: Int {
        
        return self.isoCode.hashValue
    }
    
    public static func == (lhs: Country, rhs: Country) -> Bool {
        
        return lhs.isoCode.lowercased() == rhs.isoCode.lowercased()
    }
    
    // MARK: Methods
    
    public required init(isoCode: String) throws {
        
        let code = isoCode.uppercased()
        
        guard Country.allISOCodes.contains(code) else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.countryCode: code]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidCountryCode.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil)
        }
        
        self.isoCode = code
        
        super.init()
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal convenience init(_ isoCode: String) throws {
        
        try self.init(isoCode: isoCode)
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
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        
        try self.init(isoCode: code)
    }
}
