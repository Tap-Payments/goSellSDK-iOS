//
//  APIClient+Card.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapNetworkManagerV2.TapBodyModel
import class    TapNetworkManagerV2.TapNetworkRequestOperation
import enum     TapNetworkManagerV2.TapURLModel

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
	
	/// Creates the card with `request` for the given `customer`.
	///
	/// - Parameters:
	///   - request: Card request.
	///   - customer: Customer identifier.
	///   - completion: Completion closure that will be called once request finishes.
	func createCard(with request: CreateCardRequest, for customer: String, completion: @escaping Completion<SavedCard>) {
		
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
    func deleteCard(with identifier: String, from customer: String, completion: @escaping Completion<DeleteCardResponse>) {
        
        let urlModel = TapURLModel.array(parameters: [customer, identifier])
        
        let operation = TapNetworkRequestOperation(path:			self.cardRoute.rawValue,
                                                   method:			.DELETE,
                                                   headers:			self.staticHTTPHeaders,
                                                   urlModel:		urlModel,
                                                   bodyModel:		nil,
                                                   responseType:	.json)
        
        self.performRequest(operation, using: self.cardRoute.decoder, completion: completion)
    }
	
	/// Lists all cards for the specified customer.
	///
	/// - Parameters:
	///   - customer: Customer identifier.
	///   - completion: Completion that will be called once request finishes.
	func listAllCards(for customer: String, completion: @escaping Completion<ListCardsResponse>) {
		
		let urlModel = TapURLModel.array(parameters: [customer])
		
		let operation = TapNetworkRequestOperation(path:			self.cardRoute.rawValue,
												   method:			.GET,
												   headers:			self.staticHTTPHeaders,
												   urlModel:		urlModel,
												   bodyModel:		nil,
												   responseType:	.json)
		
		self.performRequest(operation, using: self.cardRoute.decoder, checkSDKInitializationStatus: false, completion: completion)
	}
	
    // MARK: - Private -
    // MARK: Properties
    
    private var cardRoute: Route {
        
        return .card
    }
}
