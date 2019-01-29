//
//  APIClient+Card.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapNetworkManager.TapBodyModel
import class    TapNetworkManager.TapNetworkRequestOperation
import enum     TapNetworkManager.TapURLModel

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
	
	/// Creates the card with `request` for the given `customer`.
	///
	/// - Parameters:
	///   - request: Card request.
	///   - customer: Customer identifier.
	///   - completion: Completion closure that will be called once request finishes.
	internal func createCard(with request: CreateCardRequest, for customer: String, completion: @escaping Completion<SavedCard>) {
		
		guard let bodyDictionary = self.convertModelToDictionary(request, callingCompletionOnFailure: completion) else { return }
		
		let urlModel = TapURLModel.array(parameters: [customer])
		let body = TapBodyModel(body: bodyDictionary)
		
		let operation = TapNetworkRequestOperation(path:			self.cardRoute.rawValue,
												   method:			.POST,
												   headers:			self.staticHTTPHeaders,
												   urlModel:		urlModel,
												   bodyModel:		body,
												   responseType:	.json)
		
		self.performRequest(operation, using: self.cardRoute.decoder, completion: completion)
	}
	
    /// Deletes the card with the given `identifier` from the given `customer`.
    ///
    /// - Parameters:
    ///   - identifier: Card identifier.
    ///   - customer: Customer identifier.
    ///   - completion: Completion that will be called once request finishes.
    internal func deleteCard(with identifier: String, from customer: String, completion: @escaping Completion<DeleteCardResponse>) {
        
        let urlModel = TapURLModel.array(parameters: [customer, identifier])
        
        let operation = TapNetworkRequestOperation(path: self.cardRoute.rawValue,
                                                   method: .DELETE,
                                                   headers: self.staticHTTPHeaders,
                                                   urlModel: urlModel,
                                                   bodyModel: nil,
                                                   responseType: .json)
        
        self.performRequest(operation, using: self.cardRoute.decoder, completion: completion)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var cardRoute: Route {
        
        return .card
    }
}
