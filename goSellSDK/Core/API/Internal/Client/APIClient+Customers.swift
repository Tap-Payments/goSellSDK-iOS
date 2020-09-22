//
//  APIClient+Customers.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   TapNetworkManagerV2.TapBodyModel
import class    TapNetworkManagerV2.TapNetworkRequestOperation

internal extension APIClient {
	
	// MARK: Methods
	
	/// Creates customer with the given customer request.
	///
	/// - Parameters:
	///   - request: Customer request.
	///   - completion: Completion that will be called once request finishes.
	func createCustomer(with request: Customer.Request, completion: @escaping Completion<Customer>) {
		
		guard let bodyDictionary = self.convertModelToDictionary(request, callingCompletionOnFailure: completion) else { return }
		
		let body = TapBodyModel(body: bodyDictionary)
		
		let operation = TapNetworkRequestOperation(path:			self.customersRoute.rawValue,
												   method:			.POST,
												   headers:			self.staticHTTPHeaders,
												   urlModel:		nil,
												   bodyModel:		body,
												   responseType:	.json)
		
		self.performRequest(operation, using: self.customersRoute.decoder, completion: completion)
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	private var customersRoute: Route {
		
		return .customers
	}
}
