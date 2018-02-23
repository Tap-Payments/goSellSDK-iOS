//
//  TokenClient.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapNetworkManager.TapBodyModel
import class TapNetworkManager.TapNetworkManager
import class TapNetworkManager.TapNetworkRequestOperation
import enum TapNetworkManager.TapURLModel

/// Structure handling Token APIs.
@objcMembers public class TokenClient: NSObject {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Creates the token with the given request, calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - request: CreateTokenRequest model.
    ///   - completion: Completion that will be called when request finishes.
    ///   - token: Created token in case of success.
    ///   - error: Error in case of failure.
    public static func createToken(with request: CreateTokenRequest, completion: @escaping (_ token: Token?, _ error: TapSDKError?) -> Void) {
        
        guard let requestDictionary = self.convertModelToDictionary(request, callingCompletionOnFailure: completion) else { return }
        
        let body = TapBodyModel(body: requestDictionary)
        let operation = TapNetworkRequestOperation(path: self.path, method: .POST, headers: self.authorizationHeaders, urlModel: nil, bodyModel: body, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    /// Retrieves the token with the given identifier, calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - identifier: Token identifier.
    ///   - completion: Completion that will be called when request finishes.
    ///   - token: Retrieved token in case of success.
    ///   - error: Error in case of failure.
    public static func retrieveToken(with identifier: String, completion: @escaping (_ token: Token?, _ error: TapSDKError?) -> Void) {
        
        let urlModel = TapURLModel.array(parameters: [identifier])
        
        let operation = TapNetworkRequestOperation(path: self.path, method: .GET, headers: self.authorizationHeaders, urlModel: urlModel, bodyModel: nil, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static var networkManager: TapNetworkManager = TapNetworkManager(baseURL: TokenClient.baseURL)
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private override init() {
        
        fatalError("This class cannot be instantiated.")
    }
}

// MARK: Conformance to Client protocol.

extension TokenClient: Client {
    
    internal static let baseURLString = "https://api.tap.company/v1/"
    internal static let path = "token/"
    internal static let successStatusCodes = 200...299
    
    internal static let decoder: JSONDecoder = {
       
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return decoder
    }()
}
