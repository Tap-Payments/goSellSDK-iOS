//
//  CustomersClient.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapNetworkManager.TapBodyModel
import class TapNetworkManager.TapNetworkManager
import class TapNetworkManager.TapNetworkRequestOperation
import enum TapNetworkManager.TapURLModel

/// Structure handling Customer APIs.
@objcMembers public final class CustomersClient: NSObject {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Creates customer with the given request calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - request: CreateCustomerRequest model.
    ///   - completion: Completion that will be called when request finishes.
    ///   - customer: Created customer in case of success.
    ///   - error: Error in case of failure.
    public static func createCustomer(with request: CreateCustomerRequest, completion: @escaping (_ customer: Customer?, _ error: TapSDKError?) -> Void) {
        
        guard let bodyDictionary = self.convertModelToDictionary(request, callingCompletionOnFailure: completion) else { return }
        let bodyModel = TapBodyModel(body: bodyDictionary)
        let operation = TapNetworkRequestOperation(path: self.path, method: .POST, headers: self.authorizationHeaders, urlModel: nil, bodyModel: bodyModel, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    /// Retrieves the customer with the given identifier, calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - identifier: Customer identifier.
    ///   - completion: Completion that will be called when request finishes.
    ///   - customer: Retrieved customer in case of success.
    ///   - error: Error in case of failure.
    public static func retrieveCustomer(with identifier: String, completion: @escaping (_ customer: Customer?, _ error: TapSDKError?) -> Void) {
        
        let urlModel = TapURLModel.array(parameters: [identifier])
        let operation = TapNetworkRequestOperation(path: self.path, method: .GET, headers: self.authorizationHeaders, urlModel: urlModel, bodyModel: nil, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    /// Updates customer with the given identifer with provided details, calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - identifier: Customer identifier.
    ///   - details: UpdateCustomerRequest model.
    ///   - completion: Completion that will be called when request finishes.
    ///   - customer: Updated customer in case of success.
    ///   - error: Error in case of failure.
    public static func updateCustomer(with identifier: String, details: UpdateCustomerRequest, completion: @escaping (_ customer: Customer?, _ error: TapSDKError?) -> Void) {
        
        let urlModel = TapURLModel.array(parameters: [identifier])
        
        guard let bodyDictionary = self.convertModelToDictionary(details, callingCompletionOnFailure: completion) else { return }
        let bodyModel = TapBodyModel(body: bodyDictionary)
        
        let operation = TapNetworkRequestOperation(path: self.path, method: .PUT, headers: self.authorizationHeaders, urlModel: urlModel, bodyModel: bodyModel, responseType: .json)
        self.performRequest(operation, completion: completion)
    }
    
    /// Deletes customer with the given identifier, calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - identifier: Customer identfier.
    ///   - completion: Completion that will be called when request finishes.
    ///   - response: DeleteCustomerResponse model in case of success.
    ///   - error: Error in case of failure.
    public static func deleteCustomer(with identifier: String, completion: @escaping (_ response: DeleteCustomerResponse?, _ error: TapSDKError?) -> Void) {
        
        let urlModel = TapURLModel.array(parameters: [identifier])
        let operation = TapNetworkRequestOperation(path: self.path, method: .DELETE, headers: self.authorizationHeaders, urlModel: urlModel, bodyModel: nil, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static var networkManager: TapNetworkManager = TapNetworkManager(baseURL: CustomersClient.baseURL)
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private override init() {
        
        fatalError("This class cannot be instantiated.")
    }
}

// MARK: Conformance to Client protocol.

extension CustomersClient: Client {
    
    internal static let baseURLString = "https://api.tap.company/v1.1/"
    internal static let path = "customers/"
    internal static let successStatusCodes = 200...299
    
    internal static let decoder = JSONDecoder()
}
