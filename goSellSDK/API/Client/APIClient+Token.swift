//
//  APIClient+Token.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapNetworkManager.TapBodyModel
import class TapNetworkManager.TapNetworkRequestOperation

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Creates token with a given token request, calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - request: Create token request.
    ///   - completion: Completion that will be called when request finishes.
    internal func createToken(with request: CreateTokenRequest, completion: @escaping Completion<Token>) {
        
        guard let bodyDictionary = self.convertModelToDictionary(request, callingCompletionOnFailure: completion) else { return }
        
        let body = TapBodyModel(body: bodyDictionary)
        let operation = TapNetworkRequestOperation(path:            self.tokenRoute.rawValue,
                                                   method:          .POST,
                                                   headers:         self.staticHTTPHeaders,
                                                   urlModel:        nil,
                                                   bodyModel:       body,
                                                   responseType:    .json)
        
        self.performRequest(operation, using: self.tokenRoute.decoder, completion: completion)
    }
    
    // MARK: - Private -
    
    private var tokenRoute: Route {
        
        return .token
    }
}
