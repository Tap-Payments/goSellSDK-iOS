//
//  SavedCard.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum TapCardVlidatorKit_iOS.CardBrand

/// Saved Card model.
@objcMembers public final class SavedCard: NSObject, OptionallyIdentifiableWithString {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// Identifier.
	public private(set) var identifier: String?
	
	/// Object type.
	public let object: String
	
	/// First six digits of card number.
	public let firstSixDigits: String
	
	/// Last 4 digits of card number.
	public let lastFourDigits: String
	
	/// Card brand.
	public let brand: CardBrand
	
	/// Card fingerprint.
	public let fingerprint: String?
	
	/// Expiration month.
	public var expirationMonth: Int {
		
		if let expiry = self.expiry {
			
			return expiry.month
		}
		
		if let month = self.exp_month {
			
			return month
		}
		
		return 0
	}
	
	/// Expiration year.
	public var expirationYear: Int {
		
		if let expiry = self.expiry {
			
			return expiry.year
		}
		
		if let year = self.exp_year {
			
			return year
		}
		
		return 0
	}
	
	/// Cardholder name.
	public let cardholderName: String?
    
    
    /// Card Type
    public let cardType: CardType?
	
	// MARK: Methods
	
	/// Checks whether two saved cards are equal.
	///
	/// - Parameters:
	///   - lhs: Left side.
	///   - rhs: Ride side.
	/// - Returns: `true` if two saved cards are equal, `false` otherwise.
	public static func == (lhs: SavedCard, rhs: SavedCard) -> Bool {
		
		return lhs.fingerprint == rhs.fingerprint
	}
	
	// MARK: - Internal -
	// MARK: Properties
	
	/// Payment option identifier.
	internal let paymentOptionIdentifier: String?
	
	/// Expiration date.
	internal let expiry: ExpirationDate?
	
	/// Currency.
	internal let currency: Currency?
	
	/// Card scheme
	internal let scheme: CardScheme?
	
	/// Supported currencies.
	internal let supportedCurrencies: [Currency]
	
	/// Order parameter
	internal let orderBy: Int
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case identifier                 = "id"
		case object                     = "object"
		case lastFourDigits             = "last_four"
		case paymentOptionIdentifier    = "payment_method_id"
		case expiry                     = "expiry"
		case brand                      = "brand"
		case fingerprint				= "fingerprint"
		case cardholderName             = "name"
		case firstSixDigits             = "first_six"
		case currency                   = "currency"
		case scheme                     = "scheme"
		case supportedCurrencies        = "supported_currencies"
		case orderBy                    = "order_by"
		case expirationMonth			= "exp_month"
		case expirationYear				= "exp_year"
        case cardType                   = "funding"
	}
	
	// MARK: Properties
	
	private var exp_month: Int?
	
	private var exp_year: Int?
	
	// MARK: Methods
	
    private init(identifier: String?, object: String, firstSixDigits: String, lastFourDigits: String, brand: CardBrand, paymentOptionIdentifier: String?, expiry: ExpirationDate?, cardholderName: String?, fingerprint: String?, currency: Currency?, scheme: CardScheme?, supportedCurrencies: [Currency], orderBy: Int, expirationMonth: Int?, expirationYear: Int?, cardType:CardType?) {
		
		self.identifier                 = identifier
		self.object                     = object
		self.firstSixDigits             = firstSixDigits
		self.lastFourDigits             = lastFourDigits
		self.brand                      = brand
		self.paymentOptionIdentifier    = paymentOptionIdentifier
		self.expiry                     = expiry
		self.cardholderName             = cardholderName
		self.fingerprint				= fingerprint
		self.currency                   = currency
		self.scheme                     = scheme
		self.supportedCurrencies        = supportedCurrencies
		self.orderBy                    = orderBy
		self.exp_month					= expirationMonth
		self.exp_year					= expirationYear
        self.cardType                   = cardType
		
		super.init()
	}
}

// MARK: - Decodable
extension SavedCard: Decodable {
	
	public convenience init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let identifier          = try container.decodeIfPresent(String.self,     		forKey: .identifier)
		let object              = try container.decode(String.self,     				forKey: .object)
		let firstSixDigits      = try container.decode(String.self,     				forKey: .firstSixDigits)
		let lastFourDigits      = try container.decode(String.self,     				forKey: .lastFourDigits)
		let brand               = try container.decodeIfPresent(CardBrand.self,         forKey: .brand) ?? .unknown
		let paymentOptionID     = try container.decodeIfPresent(String.self,     		forKey: .paymentOptionIdentifier)
		let expiry              = try container.decodeIfPresent(ExpirationDate.self,    forKey: .expiry)
		let cardholderName      = try container.decodeIfPresent(String.self,            forKey: .cardholderName)
		let fingerprint			= try container.decodeIfPresent(String.self,			forKey: .fingerprint)
		let currency            = try container.decodeIfPresent(Currency.self,          forKey: .currency)
		let scheme              = try container.decodeIfPresent(CardScheme.self,        forKey: .scheme)
		let supportedCurrencies = try container.decodeIfPresent([Currency].self,        forKey: .supportedCurrencies) ?? []
		let orderBy             = try container.decodeIfPresent(Int.self,               forKey: .orderBy) ?? 0
		let expirationMonth		= try container.decodeIfPresent(Int.self,				forKey: .expirationMonth)
		let expirationYear		= try container.decodeIfPresent(Int.self,				forKey: .expirationYear)
        var cardType:CardType?            = nil
        if let cardFunding = (try container.decodeIfPresent(String.self,  forKey: .cardType) ?? nil)
        {
            cardType = CardType(cardTypeString: cardFunding)
        }
		
		self.init(identifier:               identifier,
				  object:                   object,
				  firstSixDigits:           firstSixDigits,
				  lastFourDigits:           lastFourDigits,
				  brand:                    brand,
				  paymentOptionIdentifier:  paymentOptionID,
				  expiry:                   expiry,
				  cardholderName:           cardholderName,
				  fingerprint:				fingerprint,
				  currency:                 currency,
				  scheme:                   scheme,
				  supportedCurrencies:      supportedCurrencies,
				  orderBy:                  orderBy,
				  expirationMonth:			expirationMonth,
				  expirationYear:			expirationYear,
                  cardType:                 cardType)
	}
}

// MARK: - FilterableByCurrency
extension SavedCard: FilterableByCurrency {}

// MARK: - SortableByOrder
extension SavedCard: SortableByOrder {}
