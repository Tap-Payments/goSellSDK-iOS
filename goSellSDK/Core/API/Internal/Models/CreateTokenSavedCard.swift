//
//  CreateTokenSavedCard.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Model that holds existing card details for token creation.
internal struct CreateTokenSavedCard: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Card identifier.
    internal let cardIdentifier: String
    
    /// Customer identifier.
    internal let customerIdentifier: String
    
    // MARK: Methods
    
    /// Initializes the model with card identifier and customer identifier.
    ///
    /// - Parameters:
    ///   - cardIdentifier: Card identifier.
    ///   - customerIdentifier: Customer identifier.
    internal init(cardIdentifier: String, customerIdentifier: String) {
        
        self.cardIdentifier = cardIdentifier
        self.customerIdentifier = customerIdentifier
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case cardIdentifier     = "card_id"
        case customerIdentifier = "customer_id"
    }
}
