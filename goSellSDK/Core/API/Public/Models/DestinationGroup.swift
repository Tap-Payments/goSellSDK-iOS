//
//  DestinationGroup.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Group of destinations.
@objcMembers public final class DestinationGroup: NSObject, Decodable {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// Total amount.
	public let amount: Decimal
	
	/// Currency.
	public let currency: Currency
	
	/// Number of transfers involved.
	public let count: UInt
	
	/// Destination objects.
	public let destinations: [Destination]
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case amount			= "amount"
		case currency		= "currency"
		case count			= "count"
		case destinations	= "destination"
	}
}
