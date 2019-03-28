//
//  APIClient+Authentication.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   TapNetworkManager.TapBodyModel
import class    TapNetworkManager.TapNetworkRequestOperation
import enum     TapNetworkManager.TapURLModel

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Requests an authentication for the `object`, calling `completion` when request finishes.
    ///
    /// - Parameters:
    ///   - object: Authenticatable object.
    ///   - completion: Completion that will be called when request finishes.
    func requestAuthentication<T: Authenticatable>(for object: T, completion: @escaping Completion<T>) {
        
        let route = T.authenticationRoute
        
        let urlModel = TapURLModel.array(parameters: [Constants.authenticateParameter, object.identifier])
        
        let operation = TapNetworkRequestOperation(path: route.rawValue, method: .PUT, headers: self.staticHTTPHeaders, urlModel: urlModel, bodyModel: nil, responseType: .json)
        
        self.performRequest(operation, using: route.decoder, completion: completion)
    }
    
    /// Authenticates an `object` with `details` calling `completion` when request finishes.
    ///
    /// - Parameters:
    ///   - object: Authenticatable object.
    ///   - details: Authentication details.
    ///   - completion: Completion that will be called when request finishes.
    func authenticate<T: Authenticatable>(_ object: T, details: AuthenticationRequest, completion: @escaping Completion<T>) {
        
        guard let bodyDictionary = self.convertModelToDictionary(details, callingCompletionOnFailure: completion) else { return }
        
        let route = T.authenticationRoute
        
        let urlModel = TapURLModel.array(parameters: [Constants.authenticateParameter, object.identifier])
        let bodyModel = TapBodyModel(body: bodyDictionary)
        
        let operation = TapNetworkRequestOperation(path: route.rawValue, method: .POST, headers: self.staticHTTPHeaders, urlModel: urlModel, bodyModel: bodyModel, responseType: .json)
        
        self.performRequest(operation, using: route.decoder, completion: completion)
    }
}
