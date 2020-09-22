//
//  APIClient+PaymentTypes.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct TapNetworkManagerV2.TapBodyModel
import class TapNetworkManagerV2.TapNetworkRequestOperation

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Retrieves the list of available payment options with the given request.
    ///
    /// - Parameters:
    ///   - request: Payment options request model.
    ///   - completion: Completion that will be called when request finishes.
    func getPaymentOptions(with request: PaymentOptionsRequest, completion: @escaping Completion<PaymentOptionsResponse>) {
        
        guard let bodyDictionary = self.convertModelToDictionary(request, callingCompletionOnFailure: completion) else { return }
        
        let body = TapBodyModel(body: bodyDictionary)
        
        let operation = TapNetworkRequestOperation(path: self.paymentTypesRoute.rawValue,
                                                   method: .POST,
                                                   headers: self.staticHTTPHeaders,
                                                   urlModel: nil,
                                                   bodyModel: body,
                                                   responseType: .json)
        
        self.performRequest(operation, using: self.paymentTypesRoute.decoder, completion: completion)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var paymentTypesRoute: Route {
        
        return .paymentOptions
    }
}
