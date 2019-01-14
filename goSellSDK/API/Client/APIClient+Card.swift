//
//  APIClient+Card.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    TapNetworkManager.TapNetworkRequestOperation
import enum     TapNetworkManager.TapURLModel

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
    
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
