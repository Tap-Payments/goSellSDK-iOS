//
//  CountryCode.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Country model.
@objcMembers public final class Country {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Two-letters iso code.
    public let isoCode: String
    
    // MARK: Methods
	
	public static func == (lhs: Country, rhs: Country) -> Bool {
		
		return lhs.isoCode.lowercased() == rhs.isoCode.lowercased()
	}
    
    // MARK: - Internal -
    // MARK: Methods
	
	internal init(isoCode: String) throws {
		
		let code = isoCode.uppercased()
		
		guard code.tap_isIn(Country.allISOCodes) else {
			
			let userInfo = [ErrorConstants.UserInfoKeys.countryCode: code]
			let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidCountryCode.rawValue, userInfo: userInfo)
			throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
		}
		
		self.isoCode = code
	}
	
	internal convenience init(_ isoCode: String) throws {
        
        try self.init(isoCode: isoCode)
    }
    
    // MARK: - Private -
    
    private static let allISOCodes = Locale.isoRegionCodes.map { $0.uppercased() }
}

// MARK: - Decodable
extension Country: Decodable {
	
	public convenience init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		let code = try container.decode(String.self)
		
		try self.init(isoCode: code)
	}
}

// MARK: - Encodable
extension Country: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.isoCode)
    }
}

// MARK: - Hashable
extension Country: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		
		hasher.combine(self.isoCode)
	}
}
