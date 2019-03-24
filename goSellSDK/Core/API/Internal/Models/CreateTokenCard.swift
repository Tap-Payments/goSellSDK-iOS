//
//  CreateTokenCard.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Model that holds card details required for token creation.
internal struct CreateTokenCard {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Card address.
    internal private(set) var address: Address?
    
    // MARK: Methods
    
    internal init(number: String, expirationMonth: String, expirationYear: String, cvc: String, cardholderName: String, address: Address?) {
        
        self.sensitiveCardData = SensitiveCardData(number: number, month: expirationMonth, year: expirationYear, cvc: cvc, name: cardholderName)
        self.address = address
    }
    
    // MARK: - Fileprivate -
    
    fileprivate struct SensitiveCardData: SecureEncodable {
        
        fileprivate init(number: String, month: String, year: String, cvc: String, name: String) {
            
            self.number = number
            self.expirationMonth = month
            self.expirationYear = year
            self.cvc = cvc
            self.cardholderName = name
        }
        
        private let number: String
        private let expirationMonth: String
        private let expirationYear: String
        private let cvc: String
        private let cardholderName: String
        
        private enum CodingKeys: String, CodingKey {
            
            case number             = "number"
            case expirationMonth    = "exp_month"
            case expirationYear     = "exp_year"
            case cvc                = "cvc"
            case cardholderName     = "name"
        }
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case sensitiveCardData  = "crypted_data"
        case address            = "address"
    }
    
    // MARK: Properties
    private let sensitiveCardData: SensitiveCardData
}

// MARK: - Encodable
extension CreateTokenCard: Encodable {
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
    internal func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode            (try self.sensitiveCardData.secureEncoded(),    forKey: .sensitiveCardData)
        try container.encodeIfPresent   (self.address,                                  forKey: .address)
    }
}
