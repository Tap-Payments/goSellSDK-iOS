//
//  Client.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapNetworkManager.TapNetworkManager
import class TapNetworkManager.TapNetworkRequestOperation

// MARK: - Client Definition -

/// Client protocol.
internal protocol Client {
    
    // MARK: Properties
    
    /// Base URL.
    static var baseURLString: String { get }
    
    /// Network manager.
    static var networkManager: TapNetworkManager { get }
    
    /// These status codes will be treated as success.
    static var successStatusCodes: CountableClosedRange<Int> { get }
    
    /// Relative URL path.
    static var path: String { get }
    
    static var decoder: JSONDecoder { get }
}

// MARK: - Internal Client -

internal extension Client {
    
    // MARK: Properties
    
    /// Generates URL from baseURLString.
    internal static var baseURL: URL {
        
        guard let result = URL(string: Self.baseURLString) else {
            
            fatalError("Base URL is wrong. Please contact the developer on this issue.")
        }
        
        return result
    }
    
    /// Authorization headers.
    internal static var authorizationHeaders: [String: String] {
        
        let authKey = goSellSDK.authenticationKey
        
        guard authKey.count > 0 else {
            
            fatalError("Auth key is not set.")
        }
        
        return [
            
            "Authorization": "Bearer \(authKey)"
        ]
    }
    
    // MARK: Methods
    
    /// Performs request.
    ///
    /// - Parameters:
    ///   - operation: Request operation.
    ///   - completion: Completion closure.
    ///   - response: Response object in case of success.
    ///   - error: Error in case of failure.
    internal static func performRequest<ResponseType>(_ operation: TapNetworkRequestOperation, completion: @escaping (_ response: ResponseType?, _ error: TapSDKError?) -> Void) where ResponseType: Response {
        
        self.networkManager.performRequest(operation) { (dataTask, response, error) in
            
            self.handleResponse(response, error: error, in: dataTask, completion: completion)
        }
    }
    
    /// Converts Encodable model into its dictionary representation. Calls completion closure in case of failure.
    ///
    /// - Parameters:
    ///   - model: Model to encode.
    ///   - completion: Failure completion closure.
    ///   - response: Response object in case of success. Here - always nil.
    ///   - error: Error in case of failure. If the closure is called it will never become nil.
    /// - Returns: Dictionary.
    internal static func convertModelToDictionary<ResponseType>(_ model: Encodable, callingCompletionOnFailure completion: (_ response: ResponseType?, _ error: TapSDKError?) -> Void) -> [String: Any]? where ResponseType: Response {
        
        var modelDictionary: [String: Any]
        
        do {
            
            modelDictionary = try model.asDictionary()
        }
        catch let error {
            
            completion(nil, TapSDKKnownError(type: .serialization, error: error, response: nil))
            return nil
        }
        
        return modelDictionary
    }
}

// MARK: - Private Client -

private extension Client {

    // MARK: Methods
    
    private static func handleResponse<ResponseType>(_ response: Any?, error: Error?, in dataTask: URLSessionDataTask?, completion: (ResponseType?, TapSDKError?) -> Void) where ResponseType: Response {
        
        if let nonnullError = error {
            
            completion(nil, TapSDKKnownError(type: .network, error: nonnullError, response: dataTask?.response))
            return
        }
        
        if let dataTaskError = dataTask?.error {
            
            completion(nil, TapSDKKnownError(type: .network, error: dataTaskError, response: dataTask?.response))
            return
        }
        
        if let dictionary = response as? [String: Any], let httpResponse = dataTask?.response as? HTTPURLResponse {
            
            let statusCode = httpResponse.statusCode
            if self.successStatusCodes.contains(statusCode) {
                
                do {
                    
                    let parsedResponse = try ResponseType(dictionary: dictionary, using: self.decoder)
                    completion(parsedResponse, nil)
                    return
                }
                catch let parsingError {
                    
                    completion(nil, TapSDKKnownError(type: .serialization, error: parsingError, response: httpResponse))
                    return
                }
            }
            else {
                
                do {
                    
                    let parsedError = try APIError(dictionary: dictionary, using: self.decoder)
                    completion(nil, TapSDKAPIError(error: parsedError, response: httpResponse))
                    return
                }
                catch let parsingError {
                    
                    completion(nil, TapSDKKnownError(type: .serialization, error: parsingError, response: httpResponse))
                    return
                }
            }
        }
        else {
            
            completion(nil, TapSDKUnknownError(dataTask: dataTask))
            return
        }
    }
}
