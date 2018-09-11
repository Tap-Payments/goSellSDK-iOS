//
//  Currency.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Currency structure.
@objcMembers public final class Currency: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Lowercased 3-letters currency ISO code.
    public let isoCode: String
    
    /// Pretty printed object description.
    public override var description: String {
        
        let locale = Locale(identifier: goSellSDK.localeIdentifier)
        let currencyName = locale.localizedString(forCurrencyCode: self.isoCode)
        if let nonnullCurrencyName = currencyName {
            
            return "\(CurrencyFormatter.shared.localizedCurrencySymbol(for: self.isoCode)) " + "(\(nonnullCurrencyName))"
        }
        else {
            
            return CurrencyFormatter.shared.localizedCurrencySymbol(for: self.isoCode)
        }
    }
    
    // MARK: Methods
    
    /// Initializes currency with 3-lettered ISO code.
    ///
    /// - Parameter isoCode: ISO code.
    /// - Throws: Invalid currency exception.
    @objc(initWithISOCode:error:) public init(isoCode: String) throws {
        
        let code = isoCode.lowercased()
        
        guard Currency.allISOCodes.contains(code) else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.currencyCode: code]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidCurrency.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil)
        }
        
        self.isoCode = code
        
        super.init()
    }

    /// Initializes the currench with 3-lettered ISO code.
    ///
    /// - Parameter isoCode: 3-lettered ISO code.
    /// - Warning: This method returns `nil` if ISO code is not valid.
    @objc(initWithISOCode:) public convenience init?(_ isoCode: String) {
        
        try? self.init(isoCode: isoCode)
    }
    
    /// Creates and returns an instance of `Currency` with the given `isoCode`.
    ///
    /// - Parameter isoCode: Three-lettered currency ISO code.
    /// - Returns: An instance of `Currency` or `nil` if ISO code is invalid.
    @objc(withISOCode:) public static func with(isoCode: String) -> Currency? {
        
        return Currency(isoCode)
    }
    
    /// Checks if 2 objects are equal.
    ///
    /// - Parameters:
    ///   - lhs: First object.
    ///   - rhs: Second object.
    /// - Returns: `true` if 2 objects are equal, `false` otherwise.
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        
        return lhs.isoCode == rhs.isoCode
    }
    
    /// Checks if the receiver is equal to `object.`
    ///
    /// - Parameter object: Object to test equality with.
    /// - Returns: `true` if the receiver is equal to `object`, `false` otherwise.
    public override func isEqual(_ object: Any?) -> Bool {
        
        guard let other = object as? Currency else { return false }
        return self.isoCode == other.isoCode
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private static let allISOCodes = Locale.isoCurrencyCodes.map { $0.lowercased() }
}

// MARK: - CountableCasesEnum
extension Currency: CountableCasesEnum {
    
    public static let all: [Currency] = Currency.allISOCodes.compactMap { try? Currency(isoCode: $0) }
}

// MARK: - Encodable
extension Currency: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.isoCode)
    }
}

// MARK: - Decodable
extension Currency: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        
        try self.init(isoCode: code)
    }
}
