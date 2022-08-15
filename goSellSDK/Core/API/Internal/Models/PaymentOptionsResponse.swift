//
//  PaymentOptionsResponse.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//
import TapCardVlidatorKit_iOS

/// Payment Options Response model.
internal struct PaymentOptionsResponse: IdentifiableWithString {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Object identifier.
    internal let identifier: String
    
    /// Order identifier.
    internal private(set) var orderIdentifier: String?
    
    /// Object type.
    internal let object: String
    
    /// List of available payment options.
    internal let paymentOptions: [PaymentOption]
    
    /// Transaction currency.
    internal let currency: Currency
    
    /// Merchant iso country code.
    internal let merchantCountryCode: String?
    
    /// Amount for different currencies.
    internal let supportedCurrenciesAmounts: [AmountedCurrency]
    
    /// Saved cards.
    internal var savedCards: [SavedCard]?
    
    /// Merchant data
    internal var merchant: Merchant?
    
    /// Order data
    internal var order: Order?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
		
		case currency                   = "currency"
        case identifier                 = "id"
		case object                     = "object"
		case paymentOptions             = "payment_methods"
		case supportedCurrenciesAmounts = "supported_currencies"
		
        case orderIdentifier            = "order_id"
        case savedCards                 = "cards"
        
        case merchantCountryCode        = "country"
        
        case merchant                   = "merchant"
        
        case order                      = "order"
    }
	
	// MARK: Methods
	
	private init(identifier:					String,
				 orderIdentifier:				String?,
				 object:						String,
				 paymentOptions:				[PaymentOption],
				 currency:						Currency,
				 supportedCurrenciesAmounts:	[AmountedCurrency],
				 savedCards:					[SavedCard]?,
                 merchantCountryCode:           String?,
                 merchant:                      Merchant?,
                 order:                         Order?) {
		
		self.identifier					= identifier
		self.orderIdentifier			= orderIdentifier
		self.object						= object
		self.paymentOptions				= paymentOptions
		self.currency					= currency
		self.supportedCurrenciesAmounts	= supportedCurrenciesAmounts
		self.savedCards					= savedCards
        self.merchantCountryCode        = merchantCountryCode
        self.merchant                   = merchant
        self.order                      = order
	}
}

// MARK: - Decodable
extension PaymentOptionsResponse: Decodable {
	
	internal init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let identifier 					= try container.decode(String.self, forKey: .identifier)
		let orderIdentifier				= try container.decodeIfPresent(String.self, forKey: .orderIdentifier)
		let object						= try container.decode(String.self, forKey: .object)
		var paymentOptions				= try container.decode([PaymentOption].self, forKey: .paymentOptions)
		let currency					= try container.decode(Currency.self, forKey: .currency)
		let supportedCurrenciesAmounts	= try container.decode([AmountedCurrency].self, forKey: .supportedCurrenciesAmounts)
		var savedCards					= try container.decodeIfPresent([SavedCard].self, forKey: .savedCards)
        let merchantCountryCode         = try container.decodeIfPresent(String.self, forKey: .merchantCountryCode)
        let merchant                    = try container.decodeIfPresent(Merchant.self, forKey: .merchant)
        let order                       = try container.decodeIfPresent(Order.self, forKey: .order)
        
        if let nonNullMerchant = merchant {
            SettingsDataManager.shared.settings?.merchant = nonNullMerchant
        }
        /*let applePayPaymentOption:PaymentOption = PaymentOption(identifier: "2", brand: .apple, title: "APPLE PAY", imageURL: URL(string: "https://i.ibb.co/sP9Tkck/Apple-Pay-Pay-With-2x.png")!, paymentType: .apple, sourceIdentifier: "src_kw.knet", supportedCardBrands: [.apple], extraFees: [], supportedCurrencies: [try! Currency.init(isoCode: "KWD"),try! Currency.init(isoCode: "SAR"),try! Currency.init(isoCode: "AED"),try! Currency.init(isoCode: "BHD")], orderBy: 2)
        
        paymentOptions.append(applePayPaymentOption)*/
        for i in 0...paymentOptions.count-1 {
            if paymentOptions[i].brand == .unknown {
                if paymentOptions[i].paymentType == .web {
                    paymentOptions[i].brand = CardBrand.aiywaLoyalty
                }
            }
        }
        
        paymentOptions = paymentOptions.filter { ($0.brand != .unknown || $0.paymentType == .apple) }
        
        
        // Filter saved cards based on allowed card types if any
      
        
        if let merchnantAllowedCards = Process.shared.allowedCardTypes
        {
            savedCards     = savedCards?.filter { (merchnantAllowedCards.contains($0.cardType ?? CardType(cardType: .All))) }
        }
        
		self.init(identifier:					identifier,
				  orderIdentifier:				orderIdentifier,
				  object:						object,
				  paymentOptions:				paymentOptions,
				  currency:						currency,
				  supportedCurrenciesAmounts:	supportedCurrenciesAmounts,
				  savedCards:					savedCards,
                  merchantCountryCode:          merchantCountryCode,
                  merchant:                     merchant,
                  order:                        order)
	}
}
