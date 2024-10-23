//
//  CreateTokenWithSavedCardRequest.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Request model for token creation with existing card data.
internal struct CreateTokenWithSavedCardRequest: CreateTokenRequest {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Saved card details.
    internal let savedCard: CreateTokenSavedCard
    
    internal let merchant: Merchant?
    
    internal let route: Route = .tokens
    
    // MARK: Methods
    
    /// Initializes the model with saved card.
    ///
    /// - Parameter savedCard: Saved card.
    internal init(savedCard: CreateTokenSavedCard, merchant: Merchant?) {
        self.savedCard = savedCard
        self.merchant = merchant
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case savedCard = "saved_card"
        case merchant = "merchant"
    }
}
