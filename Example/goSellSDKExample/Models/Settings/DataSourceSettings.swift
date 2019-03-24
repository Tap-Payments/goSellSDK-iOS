//
//  DataSourceSettings.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	goSellSDK.Currency
import class	goSellSDK.Customer
import class	goSellSDK.Destination
import enum		goSellSDK.SDKMode
import class	goSellSDK.Shipping
import class	goSellSDK.Tax
import enum		goSellSDK.TransactionMode

internal struct DataSourceSettings: Encodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal static let `default` = DataSourceSettings(sdkMode:								.sandbox,
													   transactionMode:						.purchase,
													   isThreeDSecure:						false,
													   canSaveSameCardMultipleTimes:		true,
													   saveCardSwitchEnabledByDefault:		true,
													   currency:							try! Currency(isoCode: "kwd"),
													   customer:							nil,
													   destinations:						[],
													   shippingList:						[],
													   taxes:								[])
	
	internal var sdkMode: SDKMode
	
	internal var transactionMode: TransactionMode
	
	internal var isThreeDSecure: Bool
	
	internal var canSaveSameCardMultipleTimes: Bool
	
	internal var isSaveCardSwitchToggleEnabledByDefault: Bool
	
	internal var currency: Currency
	
	internal var customer: EnvironmentCustomer?
	
	internal var destinations: [Destination]
	
	internal var shippingList: [Shipping]
	
	internal var taxes: [Tax]
	
	// MARK: Methods
	
	internal init(sdkMode:									SDKMode,
				  transactionMode:							TransactionMode,
				  isThreeDSecure:							Bool,
				  canSaveSameCardMultipleTimes:				Bool,
				  saveCardSwitchEnabledByDefault:			Bool,
				  currency:									Currency,
				  customer:									EnvironmentCustomer?,
				  destinations:								[Destination],
				  shippingList:								[Shipping],
				  taxes:									[Tax]) {
		
		self.sdkMode            					= sdkMode
		
		self.transactionMode    					= transactionMode
		self.isThreeDSecure							= isThreeDSecure
		self.canSaveSameCardMultipleTimes			= canSaveSameCardMultipleTimes
		self.isSaveCardSwitchToggleEnabledByDefault	= saveCardSwitchEnabledByDefault
		self.currency           					= currency
		self.customer           					= customer
		self.destinations							= destinations
		self.shippingList       					= shippingList
		self.taxes              					= taxes
	}
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case sdkMode            					= "sdk_mode"
		case transactionMode    					= "mode"
		case isThreeDSecure							= "3d_secure"
		case canSaveSameCardMultipleTimes			= "save_same_card_multiple_times"
		case isSaveCardSwitchToggleEnabledByDefault	= "is_save_card_switch_enabled_by_default"
		case currency           					= "currency"
		case customer           					= "customer"
		case destinations							= "destinations"
		case shippingList       					= "shippingList"
		case taxes              					= "taxes"
	}
}

// MARK: - Decodable
extension DataSourceSettings: Decodable {
	
	internal init(from decoder: Decoder) throws {
		
		let container						= try decoder.container(keyedBy: CodingKeys.self)
		let sdkMode         				= try container.decodeIfPresent	(SDKMode.self,				forKey: .sdkMode)									?? DataSourceSettings.default.sdkMode
		let transactionMode 				= try container.decode			(TransactionMode.self,		forKey: .transactionMode)
		let isThreeDSecure					= try container.decodeIfPresent	(Bool.self,					forKey: .isThreeDSecure)							?? DataSourceSettings.default.isThreeDSecure
		let canSaveCardMultipleTimes		= try container.decodeIfPresent	(Bool.self,					forKey: .canSaveSameCardMultipleTimes)				?? DataSourceSettings.default.canSaveSameCardMultipleTimes
		let saveCardSwitchEnabledByDefault	= try container.decodeIfPresent	(Bool.self,					forKey: .isSaveCardSwitchToggleEnabledByDefault)	?? DataSourceSettings.default.isSaveCardSwitchToggleEnabledByDefault
		let currency        				= try container.decode			(Currency.self,				forKey: .currency)
		var envCustomer     				= try container.decodeIfPresent	(EnvironmentCustomer.self,	forKey: .customer)
		let destinations					= try container.decodeIfPresent ([Destination].self,		forKey: .destinations)								?? []
		let shippingList    				= try container.decode			([Shipping].self,			forKey: .shippingList)
		let taxes           				= try container.decode			([Tax].self,				forKey: .taxes)
		
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
		
		self.init(sdkMode:							sdkMode,
				  transactionMode:					transactionMode,
				  isThreeDSecure:					isThreeDSecure,
				  canSaveSameCardMultipleTimes:		canSaveCardMultipleTimes,
				  saveCardSwitchEnabledByDefault:	saveCardSwitchEnabledByDefault,
				  currency:							currency,
				  customer:							envCustomer,
				  destinations:						destinations,
				  shippingList:						shippingList,
				  taxes:							taxes)
	}
}

// MARK: - SDKMode: Codable
extension SDKMode: Codable {
	
	public init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(Int.self)
		
		if let result = SDKMode(rawValue: rawValue) {
			
			self = result
		}
		else {
			
			self = DataSourceSettings.default.sdkMode
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.singleValueContainer()
		try container.encode(self.rawValue)
	}
}
