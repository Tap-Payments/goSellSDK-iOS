//
//  APIClient+BIN.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class TapNetworkManagerV2.TapNetworkRequestOperation
import enum TapNetworkManagerV2.TapURLModel

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Retrieves BIN number details for the given `binNumber` and calls `completion` when request finishes.
    ///
    /// - Parameters:
    ///   - binNumber: First 6 digits of the card.
    ///   - completion: Completion that will be called when request finishes.
    func getBINDetails(for binNumber: String, completion: @escaping Completion<BINResponse>) {
        
        let urlModel = TapURLModel.array(parameters: [binNumber])
        
        let operation = TapNetworkRequestOperation(path: self.binRoute.rawValue,
                                                   method: .GET,
                                                   headers: self.staticHTTPHeaders,
                                                   urlModel: urlModel,
                                                   bodyModel: nil,
                                                   responseType: .json)
        
        self.performRequest(operation, using: self.binRoute.decoder, checkSDKInitializationStatus: false, completion: completion)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var binRoute: Route {
        
        return .bin
    }
}
