//
//  APIClient+Customer.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapNetworkManager.TapBodyModel
import class	TapNetworkManager.TapNetworkRequestOperation

internal extension APIClient {
	
	// MARK: - Internal -
	// MARK: Methods
	
	/// Creates the customer with the given `request`.
	///
	/// - Parameters:
	///   - request: Customer creation request.
	///   - completion: Completion that will be called when request finishes.
	internal func createCustomer(with request: CreateCustomerRequest, completion: @escaping Completion<Customer>) {
		
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
