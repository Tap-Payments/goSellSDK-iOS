//
//  PhoneNumber.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
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
        
        self.isdNumber = isd
        self.phoneNumber = number
        
        super.init()
    }
    
    /// Intiailizes `PhoneNumber` with ISD number and a phone number.
    ///
    /// - Parameters:
    ///   - isdNumber: ISD number.
    ///   - phoneNumber: Phone number.
    /// - Warning: This method returns `nil` if you pass invalid ISD number or phone number.
    @available(swift, obsoleted: 1.0)
    @objc(initWithISDNumber:phoneNumber:)
    public convenience init?(with isdNumber: String, phoneNumber: String) {
        
        try? self.init(isdNumber: isdNumber, phoneNumber: phoneNumber)
    }
    
    /// Checks if the receiver is equal to `object.`
    ///
    /// - Parameter object: Object to test equality with.
    /// - Returns: `true` if the receiver is equal to `object`, `false` otherwise.
    public override func isEqual(_ object: Any?) -> Bool {
        
        guard let otherPhoneNumber = object as? PhoneNumber else { return false }
        
        return self.isdNumber == otherPhoneNumber.isdNumber && self.phoneNumber == otherPhoneNumber.phoneNumber
    }
    
    /// Checks if 2 objects are equal.
    ///
    /// - Parameters:
    ///   - lhs: First object.
    ///   - rhs: Second object.
    /// - Returns: `true` if 2 objects are equal, `fale` otherwise.
    public static func == (lhs: PhoneNumber, rhs: PhoneNumber) -> Bool {
        
        return lhs.isEqual(rhs)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let plusSign     = "+"
        fileprivate static let doubleZero   = "00"
        
        //@available(*, unavailable) private init() { }
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case isdNumber      = "country_code"
        case phoneNumber    = "number"
    }
    
    // MARK: Methods
    
    private static func extractISDNumber(from unextractedNumber: String) -> String {
        
        var result = unextractedNumber
        
        let prefixesToRemove = [Constants.plusSign, Constants.doubleZero]
        
        prefixesToRemove.forEach { result.tap_removePrefix($0) }
        
        return result
    }
}

// MARK: - Encodable
extension PhoneNumber: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
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
        
        let isdNumber   = try container.decodeIfPresent(String.self, forKey: .isdNumber) ?? ""
        let phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber) ?? ""
        
        try self.init(isdNumber: isdNumber, phoneNumber: phoneNumber)
    }
}

// MARK: - NSCopying
extension PhoneNumber: NSCopying {
	
	/// Creates copy of the receiver.
	///
	/// - Parameter zone: Zone.
	/// - Returns: Copy of the receiver.
	public func copy(with zone: NSZone? = nil) -> Any {
		
		return try! PhoneNumber(isdNumber: self.isdNumber, phoneNumber: self.phoneNumber)
	}
}
