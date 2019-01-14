//
//  TransactionMode.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Transaction mode.
@objc public enum TransactionMode: Int {
    
    /// Regular payment transaction.
    @objc(Purchase) case purchase
    
    /// Only authorizing the payment and capturing the amount.
    @objc(AuthorizeCapture) case authorizeCapture
    
    // MARK: - Private -
    // MARK: Properties
    
    private var stringRepresentation: String {
        
        switch self {
            
        case .purchase:         return "PURCHASE"
        case .authorizeCapture: return "AUTHORIZE_CAPTURE"

        }
    }
    
    // MARK: Methods
    
    private init(stringRepresentation: String) {
        
        switch stringRepresentation {
            
        case TransactionMode.purchase.stringRepresentation:
            
            self = .purchase
            
        case TransactionMode.authorizeCapture.stringRepresentation:
            
            self = .authorizeCapture
            
        default:
            
            self = .purchase
        }
    }
}

// MARK: - CountableCasesEnum
extension TransactionMode: CountableCasesEnum {
    
    public static let all: [TransactionMode] = [.purchase, .authorizeCapture]
}

// MARK: - CustomStringConvertible
extension TransactionMode: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .purchase: return "Payment"
        case .authorizeCapture: return "Authorize only"

        }
    }
}

// MARK: - Encodable
extension TransactionMode: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringRepresentation)
    }
}

// MARK: - Decodable
extension TransactionMode: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        self.init(stringRepresentation: stringValue)
    }
}
