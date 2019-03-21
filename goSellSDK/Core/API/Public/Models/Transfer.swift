//
//  Transfer.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Transfer model.
@objcMembers public final class Transfer: NSObject, OptionallyIdentifiableWithString, Decodable {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// Identifier.
	public private(set) var identifier: String?
	
	/// Transfer amount.
	public private(set) var amount: Decimal?
	
	/// Transfer currency
	public private(set) var currency: Currency?
	
	/// Reversed amount.
	public private(set) var reversedAmount: Decimal?
	
	/// Reversal identifiers.
	public private(set) var reversalIdentifiers: [String]?
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case identifier				= "id"
		case amount					= "amount"
		case currency				= "currency"
		case reversedAmount			= "reversed_amount"
		case reversalIdentifiers	= "reversal_id"
	}
}
