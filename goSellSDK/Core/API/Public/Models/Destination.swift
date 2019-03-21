//
//  Destination.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Destination model.
@objcMembers public final class Destination: NSObject, Codable, IdentifiableWithString {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// Destination identifier.
	public var identifier: String
	
	/// Destination amount.
	public var amount: Decimal
	
	/// Destination currency.
	public var currency: Currency
	
	/// Optional description of the destination.
	public var descriptionText: String?
	
	/// Reference number to the destination.
	public var reference: String?
	
	/// Transfer object.
	public private(set) var transfer: Transfer?
	
	// MARK: Methods
	
	/// Initializes Destination object with all the parameters.
	///
	/// - Parameters:
	///   - identifier: Destination identifier.
	///   - amount: Amount.
	///   - currency: Currency.
	///   - description: Description.
	///   - reference: Reference.
	public init(identifier: String, amount: Decimal, currency: Currency, description: String? = nil, reference: String? = nil) {
		
		self.identifier			= identifier
		self.amount				= amount
		self.currency			= currency
		self.descriptionText	= description
		self.reference			= reference
	}
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case identifier			= "id"
		case amount				= "amount"
		case currency			= "currency"
		case descriptionText	= "description"
		case reference			= "reference"
	}
}

// MARK: - NSCopying
extension Destination: NSCopying {
	
	/// Returns a copy of the receiver.
	///
	/// - Parameter zone: Zone object.
	/// - Returns: Copy of the receiver.
	public func copy(with zone: NSZone? = nil) -> Any {
		
		let result = Destination(identifier:	self.identifier,
								 amount:		self.amount,
								 currency:		self.currency.copy() as! Currency,
								 description:	self.descriptionText,
								 reference:		self.reference)
		return result
	}
}
