//
//  APIClient+Charges.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct   TapNetworkManagerV2.TapBodyModel
import class    TapNetworkManagerV2.TapNetworkRequestOperation
import enum     TapNetworkManagerV2.TapURLModel

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Creates a charge with the given charge request, calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - request: Create charge request model.
    ///   - completion: Completion that will be called when request finishes.
    ///   - charge: Created charge in case of success.
    ///   - error: Error in case of failure.
    func createCharge(with request: CreateChargeRequest, completion: @escaping Completion<Charge>) {
        
        guard let bodyDictionary = self.convertModelToDictionary(request, callingCompletionOnFailure: completion) else { return }
        
        let body = TapBodyModel(body: bodyDictionary)
        let operation = TapNetworkRequestOperation(path: self.chargesRoute.rawValue, method: .POST, headers: self.staticHTTPHeaders, urlModel: nil, bodyModel: body, responseType: .json)
        
        self.performRequest(operation, using: self.chargesRoute.decoder, completion: completion)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var chargesRoute: Route {
        
        return .charges
    }
}
