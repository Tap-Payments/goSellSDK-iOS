//
//  APIClient+BillingAddress.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class TapNetworkManagerV2.TapNetworkRequestOperation

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Retrieves billing address format details and calls completion when request finishes.
    ///
    /// - Parameter completion: Completion that will be called when request finishes.
    func getBillingAddressFormats(_ completion: @escaping Completion<BillingAddressResponse>) {
        
        let operation = TapNetworkRequestOperation(path: self.billingAddressRoute.rawValue,
                                                   method: .GET,
                                                   headers: self.staticHTTPHeaders,
                                                   urlModel: nil,
                                                   bodyModel: nil,
                                                   responseType: .json)
        
        self.performRequest(operation, using: self.billingAddressRoute.decoder, checkSDKInitializationStatus: false, completion: completion)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var billingAddressRoute: Route {
        
        return .billingAddress
    }
}
