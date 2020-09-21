//
//  AmountModificatorType.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Amount modificator type.
///
/// - percentBased: Percent-based modification.
/// - fixedAmount: Fixed amount modification.
@objc public enum AmountModificatorType: Int, CaseIterable {
    
    /// Percent-based modification.
    @objc(Percents) case percents
    
    /// Fixed amount modification.
    @objc(FixedAmount) case fixedAmount
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let percentBasedKey  = "P"
        fileprivate static let fixedAmountKey   = "F"
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
            
        case .percents:		return Constants.percentBasedKey
        case .fixedAmount:	return Constants.fixedAmountKey
            
        }
    }
    
    // MARK: Methods
    
    private init(string: String) throws {
        
        switch string {
            
        case Constants.percentBasedKey: self = .percents
        case Constants.fixedAmountKey:  self = .fixedAmount
            
        default:
            
            let userInfo = [ErrorConstants.UserInfoKeys.amountModificatorType: string]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidAmountModificatorType.rawValue, userInfo: userInfo)
			throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
        }
    }
}

// MARK: - CustomStringConvertible
extension AmountModificatorType: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .fixedAmount: return "Fixed amount"
        case .percents: return "Percents"
            
        }
    }
}

// MARK: - Decodable
extension AmountModificatorType: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        let string = try container.decode(String.self)
        try self.init(string: string)
    }
}

// MARK: - Encodable
extension AmountModificatorType: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
}
