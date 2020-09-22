//
//  APIClient+Initialization.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	TapNetworkManagerV2.TapNetworkRequestOperation
import enum		TapNetworkManagerV2.TapURLModel

internal extension APIClient {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Initializes the SDK.
    ///
    /// - Parameter completion: Closure that will be called on completion.
    func initSDK(_ completion: @escaping Completion<SDKSettings>) {
        
        var urlModel: TapURLModel?
        if let deviceID = KeychainManager.deviceID {
            
            urlModel = .dictionary(parameters: [InitializationConstants.deviceIDKey: deviceID])
        }
        else {
            
            urlModel = nil
        }
        
        let operation = TapNetworkRequestOperation(path: self.initRoute.rawValue,
                                                   method: .GET,
                                                   headers: self.staticHTTPHeaders,
                                                   urlModel: urlModel,
                                                   bodyModel: nil,
                                                   responseType: .json)
        
        self.performRequest(operation, using: self.initRoute.decoder, checkSDKInitializationStatus: false, completion: completion)
    }
    
    // MARK: - Private -
    
    private struct InitializationConstants {
        
        fileprivate static let deviceIDKey = "device_id"
    }
    
    // MARK: Properties
    
    private var initRoute: Route {
        
        return .initialization
    }
}
