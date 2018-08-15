//
//  APIClient+Retrievable.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    TapNetworkManager.TapNetworkRequestOperation
import enum     TapNetworkManager.TapURLModel

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func retrieveObject<T: Retrievable>(with identifier: String, completion: @escaping Completion<T>) {

        let urlModel = TapURLModel.array(parameters: [identifier])
        let route = T.retrieveRoute
        
        let operation = TapNetworkRequestOperation(path: route.rawValue, method: .GET, headers: self.staticHTTPHeaders, urlModel: urlModel, bodyModel: nil, responseType: .json)
        
        self.performRequest(operation, using: route.decoder, completion: completion)
    }
}
