//
//  APIClient+CardVerification.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapNetworkManagerV2.TapBodyModel
import class    TapNetworkManagerV2.TapNetworkRequestOperation

internal extension APIClient {
	
	// MARK: - Internal -
	// MARK: Methods
	
	func createCardVerification(with request: CreateCardVerificationRequest, completion: @escaping Completion<CardVerification>) {
		
		guard let bodyDictionary = self.convertModelToDictionary(request, callingCompletionOnFailure: completion) else { return }
		
		let body = TapBodyModel(body: bodyDictionary)
		
		let operation = TapNetworkRequestOperation(path:			self.cardVerificationRoute.rawValue,
												   method:			.POST,
												   headers:			self.staticHTTPHeaders,
												   urlModel:		nil,
												   bodyModel:		body,
												   responseType:	.json)
		
		self.performRequest(operation, using: self.cardVerificationRoute.decoder, completion: completion)
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	private var cardVerificationRoute: Route  {
		
		return .cardVerification
	}
}
