//
//  PhoneNumber.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Phone number model.
@objcMembers public final class PhoneNumber: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// ISD number.
    public let isdNumber: String
    
    /// Phone number (digits after country code).
    public let phoneNumber: String
    
    // MARK: Methods
    
    /// Intiailizes `PhoneNumber` with ISD number and a phone number.
    ///
    /// - Parameters:
    ///   - isdNumber: ISD number.
    ///   - phoneNumber: Phone number.
    /// - Throws: An error in case ISD number or phone number is not valid (currently checking only digits).
    public required init(isdNumber: String, phoneNumber: String) throws {
        
        let isd = PhoneNumber.extractISDNumber(from: isdNumber)
        let number = phoneNumber
        
        guard isd.length > 0 && isd.containsOnlyInternationalDigits else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.isdNumber: isd]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidISDNumber.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil)
        }
        
        guard number.length > 0 && number.containsOnlyInternationalDigits else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.phoneNumber: number]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidPhoneNumber.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil)
        }
        
        self.isdNumber = isd
        self.phoneNumber = number
        
        super.init()
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        
        guard let otherPhoneNumber = object as? PhoneNumber else { return false }
        
        return self.isdNumber == otherPhoneNumber.isdNumber && self.phoneNumber == otherPhoneNumber.phoneNumber
    }
    
    public static func == (lhs: PhoneNumber, rhs: PhoneNumber) -> Bool {
        
        return lhs.isEqual(rhs)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let plusSign     = "+"
        fileprivate static let doubleZero   = "00"
        
        @available(*, unavailable) private init() {}
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case isdNumber      = "country_code"
        case phoneNumber    = "number"
    }
    
    // MARK: Methods
    
    private static func extractISDNumber(from unextractedNumber: String) -> String {
        
        var result = unextractedNumber
        
        let prefixesToRemove = [Constants.plusSign, Constants.doubleZero]
        
        prefixesToRemove.forEach { result.removePrefix($0) }
        
        return result
    }
}

// MARK: - Encodable
extension PhoneNumber: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.isdNumber, forKey: .isdNumber)
        try container.encode(self.phoneNumber, forKey: .phoneNumber)
    }
}

// MARK: - Decodable
extension PhoneNumber: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isdNumber   = try container.decode(String.self, forKey: .isdNumber)
        let phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        
        try self.init(isdNumber: isdNumber, phoneNumber: phoneNumber)
    }
}
