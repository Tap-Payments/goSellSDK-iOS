//
//  PaymentOptionsResponse.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment Options Response model.
internal struct PaymentOptionsResponse: IdentifiableWithString {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Object identifier.
    internal let identifier: String
    
    /// Order identifier.
    internal private(set) var orderIdentifier: String
    
    /// Object type.
    internal let object: String
    
    /// List of available payment options.
    internal let paymentOptions: [PaymentOption]
    
    /// Transaction currency.
    internal let currency: Currency
    
    /// Amount for different currencies.
    internal let supportedCurrenciesAmounts: [AmountedCurrency]
    
    /// Saved cards.
    internal var savedCards: [SavedCard]?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier                 = "id"
        case orderIdentifier            = "order_id"
        case object                     = "object"
        case paymentOptions             = "payment_methods"
        case currency                   = "currency"
        case supportedCurrenciesAmounts = "supported_currencies"
        case savedCards                 = "cards"
    }
	
	// MARK: Methods
	
	private init(identifier:					String,
				 orderIdentifier:				String,
				 object:						String,
				 paymentOptions:				[PaymentOption],
				 currency:						Currency,
				 supportedCurrenciesAmounts:	[AmountedCurrency],
				 savedCards:					[SavedCard]?) {
		
		self.identifier					= identifier
		self.orderIdentifier			= orderIdentifier
		self.object						= object
		self.paymentOptions				= paymentOptions
		self.currency					= currency
		self.supportedCurrenciesAmounts	= supportedCurrenciesAmounts
		self.savedCards					= savedCards
	}
}

// MARK: - Decodable
extension PaymentOptionsResponse: Decodable {
	
	internal init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let identifier 					= try container.decode(String.self, forKey: .identifier)
		let orderIdentifier				= try container.decode(String.self, forKey: .orderIdentifier)
		let object						= try container.decode(String.self, forKey: .object)
		var paymentOptions				= try container.decode([PaymentOption].self, forKey: .paymentOptions)
		let currency					= try container.decode(Currency.self, forKey: .currency)
		let supportedCurrenciesAmounts	= try container.decode([AmountedCurrency].self, forKey: .supportedCurrenciesAmounts)
		let savedCards					= try container.decodeIfPresent([SavedCard].self, forKey: .savedCards)
		
		paymentOptions = paymentOptions.filter { $0.brand != .unknown }
		
		self.init(identifier:					identifier,
				  orderIdentifier:				orderIdentifier,
				  object:						object,
				  paymentOptions:				paymentOptions,
				  currency:						currency,
				  supportedCurrenciesAmounts:	supportedCurrenciesAmounts,
				  savedCards:					savedCards)
	}
}
