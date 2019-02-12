//
//  CardVerification.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Card Verification class.
@objcMembers public class CardVerification: NSObject, Decodable, IdentifiableWithString {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// Unique identifier.
	public let identifier: String
	
	/// Object type.
	public let object: String
	
	/// Defines whether the object was created in live mode.
	public let isLiveMode: Bool
	
	/// Verification status.
	public let status: CardVerificationStatus
	
	/// Card currency.
	public let currency: Currency
	
	/// Defines whether 3D secure is required.
	public let is3DSecureRequired: Bool
	
	/// Defines whether the card should be saved.
	public let shouldSaveCard: Bool
	
	/// Metadata.
	public let metadata: Metadata?
	
	/// Authorization transaction details (authorization used internally to verify the card).
	public let transactionDetails: TransactionDetails
	
	/// Customer, the cardholder.
	public let customer: Customer
	
	/// Source object.
	public let source: Source
	
	/// Redirect.
	public let redirect: TrackingURL
	
	/// Saved card.
	public let card: SavedCard
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case identifier			= "id"
		case object				= "object"
		case isLiveMode			= "live_mode"
		case status				= "status"
		case currency			= "currency"
		case is3DSecureRequired	= "threeDSecure"
		case shouldSaveCard		= "save_card"
		case metadata			= "metadata"
		case transactionDetails	= "transaction"
		case customer			= "customer"
		case source				= "source"
		case redirect			= "redirect"
		case card				= "card"
	}
}

// MARK: - Retrievable
extension CardVerification: Retrievable {
	
	internal static var retrieveRoute: Route {
		
		return .cardVerification
	}
}
