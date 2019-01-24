//
//  CardVerification.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

@objcMembers public class CardVerification: NSObject, Decodable, IdentifiableWithString {
	
	// MARK: - Public -
	// MARK: Properties
	
	public let identifier: String
	
	public let object: String
	
	public let isLiveMode: Bool
	
	public let status: CardVerificationStatus
	
	public let currency: Currency
	
	public let is3DSecureRequired: Bool
	
	public let shouldSaveCard: Bool
	
	public let metadata: Metadata?
	
	public let transactionDetails: TransactionDetails
	
	public let customer: Customer
	
	public let source: Source
	
	public let redirect: TrackingURL
	
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
