//
//  Settings.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	Foundation.NSLocale.Locale
import class    goSellSDK.Currency
import class    goSellSDK.Customer
import class	goSellSDK.goSellSDK
import enum		goSellSDK.SDKAppearanceMode
import enum     goSellSDK.SDKMode
import class    goSellSDK.Shipping
import class    goSellSDK.Tax
import enum     goSellSDK.TransactionMode

internal final class Settings: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
	internal static let `default` = Settings(sdkLanguage:		Language(localeIdentifier: Locale.TapLocaleIdentifier.en),
											 sdkMode:			.sandbox,
											 appearanceMode:	.default,
											 transactionMode:	.purchase,
											 currency:			try! Currency(isoCode: "kwd"),
											 customer:			nil,
											 shippingList:		[],
											 taxes:				[])
    
    internal var currency: Currency
    
    internal var customer: EnvironmentCustomer?
	
	internal var sdkLanguage: Language
	
    internal var sdkMode: SDKMode
	
	internal var appearanceMode: SDKAppearanceMode
	
    internal var transactionMode: TransactionMode
    
    internal var shippingList: [Shipping]
    
    internal var taxes: [Tax]
    
    // MARK: Methods
    
	internal init(sdkLanguage: Language, sdkMode: SDKMode, appearanceMode: SDKAppearanceMode, transactionMode: TransactionMode, currency: Currency, customer: EnvironmentCustomer?, shippingList: [Shipping], taxes: [Tax]) {
		
		self.sdkLanguage 		= sdkLanguage
        self.sdkMode            = sdkMode
		self.appearanceMode		= appearanceMode
        self.transactionMode    = transactionMode
        self.currency           = currency
        self.customer           = customer
        self.shippingList       = shippingList
        self.taxes              = taxes
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
		
		case sdkLanguage		= "sdk_language"
        case sdkMode            = "sdk_mode"
		case appearanceMode		= "appearance_mode"
        case transactionMode    = "mode"
        case currency           = "currency"
        case customer           = "customer"
        case shippingList       = "shippingList"
        case taxes              = "taxes"
    }
}

// MARK: - Decodable
extension Settings: Decodable {
    
    internal convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let sdkLanguage		= try container.decodeIfPresent(Language.self, forKey: .sdkLanguage) ?? Language(localeIdentifier: goSellSDK.language)
        let sdkMode         = try container.decodeIfPresent(SDKMode.self, forKey: .sdkMode) ?? Settings.default.sdkMode
		let appearanceMode	= try container.decodeIfPresent(SDKAppearanceMode.self, forKey: .appearanceMode) ?? Settings.default.appearanceMode
        let transactionMode = try container.decode(TransactionMode.self, forKey: .transactionMode)
        let currency        = try container.decode(Currency.self, forKey: .currency)
        var envCustomer     = try container.decodeIfPresent(EnvironmentCustomer.self, forKey: .customer)
        let shippingList    = try container.decode([Shipping].self, forKey: .shippingList)
        let taxes           = try container.decode([Tax].self, forKey: .taxes)
        
        if envCustomer == nil {
            
            let customer: Customer? = try container.decodeIfPresent(Customer.self, forKey: .customer)
            if let nonnullCustomer = customer {
                
                envCustomer = EnvironmentCustomer(customer: nonnullCustomer, environment: .sandbox)
            }
        }
        
        if envCustomer == nil {
        
            if let envCustomers: [EnvironmentCustomer] = Serializer.deserialize(), envCustomers.count > 0 {
                
                envCustomer = envCustomers.first
            }
        }
        
        if envCustomer == nil {
            
            if let customers: [Customer] = Serializer.deserialize(), customers.count > 0 {
                
                envCustomer = EnvironmentCustomer(customer: customers[0], environment: .sandbox)
            }
        }
        
		self.init(sdkLanguage: sdkLanguage, sdkMode: sdkMode, appearanceMode: appearanceMode, transactionMode: transactionMode, currency: currency, customer: envCustomer, shippingList: shippingList, taxes: taxes)
    }
}

// MARK: - Codable
extension SDKMode: Codable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        
        if let result = SDKMode(rawValue: rawValue) {
            
            self = result
        }
        else {
            
            self = Settings.default.sdkMode
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

extension SDKAppearanceMode: Codable {
	
	public init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(Int.self)
		
		if let result = SDKAppearanceMode(rawValue: rawValue) {
			
			self = result
		}
		else {
			
			self = Settings.default.appearanceMode
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.singleValueContainer()
		try container.encode(self.rawValue)
	}
}
