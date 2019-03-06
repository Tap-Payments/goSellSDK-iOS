//
//  CreateCardVerificationRequest.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct CreateCardVerificationRequest: Encodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let is3DSecureRequired: Bool?
	
	internal let shouldSaveCard: Bool
	
	internal let metadata: Metadata?
	
	internal let customer: Customer
	
	internal let currency: Currency
	
	internal let source: SourceRequest
	
	internal let redirect: TrackingURL
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case is3DSecureRequired = "threeDSecure"
		case shouldSaveCard		= "save_card"
		case metadata			= "metadata"
		case customer			= "customer"
		case currency			= "currency"
		case source				= "source"
		case redirect			= "redirect"
	}
}
