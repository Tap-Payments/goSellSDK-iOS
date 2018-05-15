//
//  APIClient+BIN.swift
//  goSellSDK
//
//  Created by Dennis Pashkov on 5/14/18.
//

import class TapNetworkManager.TapNetworkRequestOperation
import enum TapNetworkManager.TapURLModel

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Retrieves BIN number details for the given `binNumber` and calls `completion` when request finishes.
    ///
    /// - Parameters:
    ///   - binNumber: First 6 digits of the card.
    ///   - completion: Completion that will be called when request finishes.
    internal func getBINDetails(for binNumber: String, completion: @escaping Completion<BINResponse>) {
        
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
