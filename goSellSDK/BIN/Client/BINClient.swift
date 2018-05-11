//
//  BINClient.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapNetworkManager.TapNetworkManager
import class TapNetworkManager.TapNetworkRequestOperation
import enum TapNetworkManager.TapURLModel

/// BIN API client.
@objcMembers public class BINClient: NSObject {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Gets BIN number details for the given BIN number and calls completion when the request finishes.
    ///
    /// - Parameters:
    ///   - binNumber: BIN number (first 6 digits of the card number).
    ///   - completion: Completion that will be called when request finishes.
    public static func getBINNumberDetails(for binNumber: String, completion: @escaping (_ binResponse: BINResponse?, _ error: TapSDKError?) -> Void) {
        
        let urlModel = TapURLModel.array(parameters: [binNumber])
        
        let operation = TapNetworkRequestOperation(path: self.path, method: .GET, headers: self.authorizationHeaders, urlModel: urlModel, bodyModel: nil, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static var networkManager: TapNetworkManager = TapNetworkManager(baseURL: BINClient.baseURL)
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private override init() {
        
        fatalError("This class cannot be instantiated.")
    }

}

// MARK: - Client
extension BINClient: Client {
    
    internal static let baseURLString = "https://api.tap.company/v1/"
    internal static let path = "bin/"
    internal static let successStatusCodes = 200...299
    internal static let decoder = JSONDecoder()
}
