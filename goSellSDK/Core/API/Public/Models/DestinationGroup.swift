//
//  DestinationGroup.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Group of destinations.
@objcMembers public final class DestinationGroup: NSObject, Codable {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// List of Destinations.
	public var destinations: [Destination]?
	
	/// Total amount.
	public var amount: Decimal?
	
	/// Currency.
	public var currency: Currency
	
	/// Number of transfers involved.
	public var count: UInt?
	
	// MARK: Methods
	
	/// Initializes Destinations object with all the parameters.
	///
	/// - Parameters:
	///   - destinations: List of destinations.
    public init(destinations: [Destination]? = nil, amount: Decimal = 0, currency: Currency ,  count: UInt = 0) {
		
		self.destinations			= destinations
		self.amount				= amount
		self.currency				= currency
		self.count				= count

	}
	
	public convenience init?(destinations: [Destination]? = nil) {
		guard let currency = Currency("kwd") else { return nil }
		self.init(destinations: destinations, amount: 0, currency: currency, count: 0)
	}
	
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case destinations		= "destination"
		case amount			= "amount"
		case currency			= "currency"
		case count			= "count"
	}
}


