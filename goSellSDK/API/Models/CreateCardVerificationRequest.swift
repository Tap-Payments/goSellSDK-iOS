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
	
	internal let source: SourceRequest
	
	internal let redirect: TrackingURL
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case is3DSecureRequired = "threeDSecure"
		case shouldSaveCard		= "save_card"
		case metadata			= "metadata"
		case customer			= "customer"
		case source				= "source"
		case redirect			= "redirect"
	}
}

/*
{
"threeDSecure": true, — optional
"save_card": false,— optional
"metadata": { — optional
"sample string 1": "sample string 2",
"sample string 3": "sample string 4"
},
"customer": { — required, if save card, true
"id": "",
"first_name": "sample",
"middle_name": "sample",
"last_name": "a",
"email": "test@test.com"
},
"source": { —required
"id": "tok_9elMw7JGtbKgEXqaRs06Pk13"
},
"redirect": { —required, if threeDsecure check done by Tap
"url": "https://test.com"
},
"card": true,
"risk": true,
"issuer": true,
"promo": true,
"loyalty": true
}
*/
