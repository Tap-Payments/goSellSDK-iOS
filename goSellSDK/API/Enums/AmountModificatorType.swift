//
//  AmountModificatorType.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Amount modificator type.
///
/// - percentBased: Percent-based modification.
/// - fixedAmount: Fixed amount modification.
@objc public enum AmountModificatorType: Int {
    
    /// Percent-based modification.
    case percentBased
    
    /// Fixed amount modification.
    case fixedAmount
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let percentBasedKey  = "P"
        fileprivate static let fixedAmountKey   = "F"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
            
        case .percentBased: return Constants.percentBasedKey
        case .fixedAmount:  return Constants.fixedAmountKey
            
        }
    }
    
    // MARK: Methods
    
    private init(string: String) throws {
        
        switch string {
            
        case Constants.percentBasedKey: self = .percentBased
        case Constants.fixedAmountKey:  self = .fixedAmount
            
        default:
            
            let userInfo = [ErrorConstants.UserInfoKeys.amountModificatorType: string]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidAmountModificatorType.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil)
        }
    }
}

// MARK: - CountableCasesEnum
extension AmountModificatorType: CountableCasesEnum {
    
    public static var all: [AmountModificatorType] {
        
        return [.percentBased, .fixedAmount]
    }
}

// MARK: - CustomStringConvertible
extension AmountModificatorType: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .fixedAmount: return "Fixed amount"
        case .percentBased: return "Percents"
            
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
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
}
