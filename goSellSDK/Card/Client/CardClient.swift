//
//  CardClient.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapNetworkManager.TapBodyModel
import class TapNetworkManager.TapNetworkManager
import class TapNetworkManager.TapNetworkRequestOperation
import enum TapNetworkManager.TapURLModel

/// Structure handling Card APIs.
@objcMembers public class CardClient: NSObject {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Creates card for the given customer with request, calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - customer: Customer identifier.
    ///   - request: Create card request model.
    ///   - completion: Completion that will be called when request finishes.
    ///   - card: Created card in case of success.
    ///   - error: Error in case of failure.
    public static func createCard(for customer: String, with request: CreateCardRequest, completion: @escaping (_ card: Card?, _ error: TapSDKError?) -> Void) {
        
        let urlModel = TapURLModel.array(parameters: [customer])
        
        guard let requestDictionary = self.convertModelToDictionary(request, callingCompletionOnFailure: completion) else { return }
        
        let bodyModel = TapBodyModel(body: requestDictionary)
        let operation = TapNetworkRequestOperation(path: self.path, method: .POST, headers: self.authorizationHeaders, urlModel: urlModel, bodyModel: bodyModel, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    /// Retrieves the card for the given customer with the given card identifier, calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - customer: Customer identifier.
    ///   - cardIdentifier: Card identifier.
    ///   - completion: Completion that will be called when request finishes.
    ///   - card: Retrived card in case of success.
    ///   - error: Error in case of failure.
    public static func retrieveCard(for customer: String, cardIdentifier: String, completion: @escaping (_ card: Card?, _ error: TapSDKError?) -> Void) {
        
        let urlModel = TapURLModel.array(parameters: [customer, cardIdentifier])
        let operation = TapNetworkRequestOperation(path: self.path, method: .GET, headers: self.authorizationHeaders, urlModel: urlModel, bodyModel: nil, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    /// Retrieves all cards for the given customer calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - customer: Customer identifier.
    ///   - completion: Completion that will be called when request finishes.
    ///   - response: RetrieveCardsResponse model in case of success.
    ///   - error: Error in case of failure.
    public static func retrieveAllCards(for customer: String, completion: @escaping (_ response: RetrieveCardsResponse?, _ error: TapSDKError?) -> Void) {
        
        let urlModel = TapURLModel.array(parameters: [customer])
        let operation = TapNetworkRequestOperation(path: self.path, method: .GET, headers: self.authorizationHeaders, urlModel: urlModel, bodyModel: nil, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    /// Deletes the card for a given customer with the given card identifier calling completion when request finishes.
    ///
    /// - Parameters:
    ///   - customer: Customer identifier.
    ///   - cardIdentifier: Card identifier.
    ///   - completion: Completion that will be called when request finishes.
    ///   - response: DeleteCardResponse model in case of success.
    ///   - error: Error in case of failure.
    public static func deleteCard(for customer: String, cardIdentifier: String, completion: @escaping (_ response: DeleteCardResponse?, _ error: TapSDKError?) -> Void) {
        
        let urlModel = TapURLModel.array(parameters: [customer, cardIdentifier])
        let operation = TapNetworkRequestOperation(path: self.path, method: .DELETE, headers: self.authorizationHeaders, urlModel: urlModel, bodyModel: nil, responseType: .json)
        
        self.performRequest(operation, completion: completion)
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal static var networkManager: TapNetworkManager = TapNetworkManager(baseURL: CardClient.baseURL)
    
    // MARK: - Private -
    // MARK: Methods
    
    @available(*, unavailable) private override init() {
        
        fatalError("This class cannot be instantiated.")
    }
}

// MARK: Conformance to Client protocol.
extension CardClient: Client {
    
    internal static let baseURLString = "https://api.tap.company/v1/"
    internal static let path = "card/"
    internal static let successStatusCodes = 200...299
    
    internal static let decoder = JSONDecoder()
}
