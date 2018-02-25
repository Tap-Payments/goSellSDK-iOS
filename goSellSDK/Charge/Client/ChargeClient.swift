//
//  ChargeClient.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct Foundation.NSDate.Date
import class Foundation.NSJSONSerialization.JSONDecoder
import class Foundation.NSNumberFormatter.NumberFormatter
import class Foundation.NSObject.NSObject
import struct TapNetworkManager.TapBodyModel
import class TapNetworkManager.TapNetworkManager
import class TapNetworkManager.TapNetworkRequestOperation
import enum TapNetworkManager.TapURLModel

/// Structure handling Charge APIs.
@objcMembers public class ChargeClient: NSObject {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Creates a charge with the given charge request, calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - request: Create charge request model.
    ///   - completion: Completion that will be called when request finishes.
    ///   - charge: Created charge in case of success.
    ///   - error: Error in case of failure.
    public static func createCharge(with request: CreateChargeRequest, completion: @escaping (_ charge: Charge?, _ error: TapSDKError?) -> Void) {
        
        guard let bodyDictionary = self.convertModelToDictionary(request, callingCompletionOnFailure: completion) else { return }
        
        let body = TapBodyModel(body: bodyDictionary)
        let operation = TapNetworkRequestOperation(path: self.path, method: .POST, headers: self.authorizationHeaders, urlModel: nil, bodyModel: body, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    /// Retrieves a charge with the given identifier, calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - identifier: Charge identifier.
    ///   - completion: Completion that will be called when request finishes.
    ///   - charge: Retrieved charge in case of success.
    ///   - error: Error in case of failure.
    public static func retrieveCharge(with identifier: String, completion: @escaping (_ charge: Charge?, _ error: TapSDKError?) -> Void) {
        
        let urlModel = TapURLModel.array(parameters: [identifier])
        
        let operation = TapNetworkRequestOperation(path: self.path, method: .GET, headers: self.authorizationHeaders, urlModel: urlModel, bodyModel: nil, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    /// Updates the charge with a given identifier, update details and calls completion when request finishes.
    ///
    /// - Parameters:
    ///   - identifier: Charge identifier.
    ///   - details: Update charge request model.
    ///   - completion: Completion that will be called when request finishes.
    ///   - charge: Updated charge in case of success.
    ///   - error: Error in case of failure.
    public static func updateCharge(with identifier: String, details: UpdateChargeRequest, completion: @escaping (_ charge: Charge?, _ error: TapSDKError?) -> Void) {
        
        let urlModel = TapURLModel.array(parameters: [identifier])
        
        guard let bodyDictionary = self.convertModelToDictionary(details, callingCompletionOnFailure: completion) else { return }
        let bodyModel = TapBodyModel(body: bodyDictionary)
        
        let operation = TapNetworkRequestOperation(path: self.path, method: .PUT, headers: self.authorizationHeaders, urlModel: urlModel, bodyModel: bodyModel, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static var networkManager: TapNetworkManager = TapNetworkManager(baseURL: ChargeClient.baseURL)
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private override init() {
        
        fatalError("This class cannot be instantiated.")
    }
}

// MARK: Conformance to Client protocol.

extension ChargeClient: Client {
    
    internal static let baseURLString = "https://api.tap.company/v1/"
    internal static let path = "charges/"
    internal static let successStatusCodes = 200...299
    
    internal static let decoder: JSONDecoder = {
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .custom { (aDecoder) -> Date in
            
            let container = try aDecoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let double = NumberFormatter().number(from: dateString)?.doubleValue ?? 0.0
            return Date(timeIntervalSince1970: double / 1000.0)
        }
        
        return decoder
    }()
}
