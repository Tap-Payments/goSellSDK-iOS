//
//  SourcePaymentType.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

@objc public enum SourcePaymentType: Int {
    
    case debitCard
    case creditCard
    case prepaidCard
    case prepaidWallet
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringValue: String {
        
        switch self {
            
        case .debitCard:        return "DEBIT_CARD"
        case .creditCard:       return "CREDIT_CARD"
        case .prepaidCard:      return "PREPAID_CARD"
        case .prepaidWallet:    return "PREPAID_WALLET"

        }
    }
    
    // MARK: Methods
    
    private init(_ stringValue: String) throws {
        
        switch stringValue {
            
        case SourcePaymentType.debitCard.stringValue:       self = .debitCard
        case SourcePaymentType.creditCard.stringValue:      self = .creditCard
        case SourcePaymentType.prepaidCard.stringValue:     self = .prepaidCard
        case SourcePaymentType.prepaidWallet.stringValue:   self = .prepaidWallet

        default:
            
            throw ErrorUtils.createEnumStringInitializationError(for: SourcePaymentType.self, value: stringValue)
        }
    }
}

// MARK: - Decodable
extension SourcePaymentType: Decodable {
    
    public init(from decoder: Decoder) throws {
     
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        try self.init(stringValue)
    }
}

// MARK: - Encodable
extension SourcePaymentType: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
}
