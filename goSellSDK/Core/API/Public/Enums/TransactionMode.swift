//
//  TransactionMode.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Transaction mode.
@objc public enum TransactionMode: Int, CaseIterable {
    
    /// Regular payment transaction.
    @objc(Purchase) case purchase
    
    /// Only authorizing the payment and capturing the amount.
    @objc(AuthorizeCapture) case authorizeCapture
	
	/// Mode to save the card only.
	@objc(CardSaving) case cardSaving
	
	/// Mode to tokenize the card.
	@objc(CardTokenization) case cardTokenization
    
    /// Mode to invalid transaction
    @objc(InvalidTransaction) case invalidTransactionMode
	
	// MARK: - Internal -
	// MARK: Properties
	
	/// Default transaction mode.
	internal static let `default`: TransactionMode = .invalidTransactionMode
	
    // MARK: - Private -
    // MARK: Properties
    
    private var stringRepresentation: String {
        
        switch self {
            
        case .purchase:                 return "PURCHASE"
        case .authorizeCapture:         return "AUTHORIZE_CAPTURE"
		case .cardSaving:               return "SAVE_CARD"
		case .cardTokenization:         return "TOKENIZE_CARD"
        case .invalidTransactionMode:   return "INVALID_MODE"

        }
    }
    
    // MARK: Methods
    
    private init(stringRepresentation: String) {
        
        switch stringRepresentation {
            
        case TransactionMode.purchase.stringRepresentation:
            
            self = .purchase
            
        case TransactionMode.authorizeCapture.stringRepresentation:
            
            self = .authorizeCapture
			
		case TransactionMode.cardSaving.stringRepresentation:
			
			self = .cardSaving
			
		case TransactionMode.cardTokenization.stringRepresentation:
			
			self = .cardTokenization
			
        default:
            
            self = .invalidTransactionMode
        }
    }
}

// MARK: - CustomStringConvertible
extension TransactionMode: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .purchase:                 return "Payment"
        case .authorizeCapture:         return "Authorize only"
		case .cardSaving:               return "Save Card"
		case .cardTokenization:         return "Tokenize Card"
        case .invalidTransactionMode:   return "Invalid Mode"

        }
    }
}

// MARK: - Encodable
extension TransactionMode: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
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
