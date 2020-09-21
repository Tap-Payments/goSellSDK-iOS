//
//  SourcePaymentType.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Source payment type enum.
@objc public enum SourcePaymentType: Int {
    
    /// Debit card.
    case debitCard
    
    /// Credit card.
    case creditCard
    
    /// Prepaid card.
    case prepaidCard
    
    /// Prepaid wallet.
    case prepaidWallet
    
    /// Other.
    case null
    
    // MARK: - Private -
	
	private struct RawValues {
		
		fileprivate static let table: [SourcePaymentType: [String]] = [
		
			.debitCard:		RawValues.debitCard,
			.creditCard:	RawValues.creditCard,
			.prepaidCard:	RawValues.prepaidCard,
			.prepaidWallet:	RawValues.prepaidWallet,
			.null:			RawValues.null
		]
		
		private static let debitCard		= ["DEBIT_CARD",		"DEBIT"]
		private static let creditCard		= ["CREDIT_CARD",		"CREDIT"]
		private static let prepaidCard		= ["PREPAID_CARD",		"PREPAID"]
		private static let prepaidWallet	= ["PREPAID_WALLET",	"WALLET"]
		private static let null				= ["null"]
		
		//@available(*, unavailable) private init() { }
	}
	
	// MARK: Properties
	
	private var stringValue: String {
		
		return RawValues.table[self]!.first!
	}
	
    // MARK: Methods
    
    private init(_ stringValue: String) throws {
		
		for (type, rawValues) in RawValues.table {
			
			guard rawValues.contains(stringValue) else { continue }
			
			self = type
			return
		}
		
		throw ErrorUtils.createEnumStringInitializationError(for: SourcePaymentType.self, value: stringValue)
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
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
}
