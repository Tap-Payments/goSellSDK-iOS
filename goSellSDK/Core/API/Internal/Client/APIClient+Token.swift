//
//  APIClient+Token.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapNetworkManagerV2.TapBodyModel
import class	TapNetworkManagerV2.TapNetworkRequestOperation

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Creates token with a given token request, calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - request: Create token request.
    ///   - completion: Completion that will be called when request finishes.
    func createToken(with request: CreateTokenRequest, completion: @escaping Completion<Token>) {
        guard let bodyDictionary = self.convertModelToDictionary(request, callingCompletionOnFailure: completion) else { return }
        
        
        let body = TapBodyModel(body: bodyDictionary)
        let operation = TapNetworkRequestOperation(path:            request.route.rawValue,
                                                   method:          .POST,
                                                   headers:         self.staticHTTPHeaders,
                                                   urlModel:        nil,
                                                   bodyModel:       body,
                                                   responseType:    .json)
        
        self.performRequest(operation, using: request.route.decoder, completion: completion)
    }
}
