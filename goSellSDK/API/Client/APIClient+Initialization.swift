//
//  APIClient+Initialization.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapApplication.ApplicationPlistInfo
import class TapNetworkManager.TapNetworkRequestOperation

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func initSDK(_ completion: @escaping Completion<SDKSettings>) {
        
        let operation = TapNetworkRequestOperation(path: self.initRoute.rawValue,
                                                   method: .GET,
                                                   headers: self.staticHTTPHeaders,
                                                   urlModel: nil,
                                                   bodyModel: nil,
                                                   responseType: .json)
        
        self.performRequest(operation, using: self.initRoute.decoder, checkSDKInitializationStatus: false, completion: completion)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var initRoute: Route {
        
        return Route.initialization
    }
}
