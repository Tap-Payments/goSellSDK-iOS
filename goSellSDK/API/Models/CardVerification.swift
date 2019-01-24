//
//  CardVerification.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct CardVerification: Decodable, IdentifiableWithString {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let identifier: String
	
	internal let object: String
	
	internal let isLiveMode: Bool
	
	internal let status: CardVerificationStatus
	
	internal let currency: Currency
	
	internal let is3DSecureRequired: Bool
	
	internal let shouldSaveCard: Bool
	
	internal let metadata: Metadata?
	
	internal let transactionDetails: TransactionDetails
	
	internal let customer: Customer
	
	internal let source: Source
	
	internal let redirect: TrackingURL
	
	internal let card: SavedCard
	
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

/*
{
"id": "vry_Bc2e2420191742r4MD2201766",
"object": "verify_card",
"live_mode": false,
"api_version": "V2",
"status": "INITIATED",
"currency": "KWD",
"threeDSecure": true,
"save_card": false,
"metadata": {
"sample string 1": "sample string 2",
"sample string 3": "sample string 4"
},
"transaction": {
"timezone": "UTC+03:00",
"created": "1548178946657",
"url": "https://sandbox.payments.tap.company/test_gosell/v2/payment/response.aspx?auth=r7HqRZZYgyKPcnRCVuQxp8UBseBHVTXxo0s5kUKhfCI%3d&sess=Y%2bZSFDgls44%3d&token=r7HqRZZYgyKPcnRCVuQxp8UBseBHVTXxMUEkVPp9vLFduJ2Ph2pxhw%3d%3d"
},
"customer": {
"first_name": "sample",
"middle_name": "sample",
"last_name": "a",
"email": "test@test.com",
"phone": {
"country_code": "965",
"number": "50000000"
}
},
"source": {
"object": "token",
"id": "tok_Dok1cb5REfSvdB0y9MKG4i8e"
},
"redirect": {
"status": "PENDING",
"url": "https://test.com"
},
"card": {
"object": "card",
"first_six": "512345",
"last_four": "0008"
},
"risk": false,
"issuer": false,
"promo": false,
"loyalty": false
}
*/
