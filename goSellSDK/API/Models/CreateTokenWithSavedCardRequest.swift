//
//  CreateTokenWithSavedCardRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Request model for token creation with existing card data.
internal struct CreateTokenWithSavedCardRequest: CreateTokenRequest {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Saved card details.
    internal let savedCard: CreateTokenSavedCard
    
    // MARK: Methods
    
    /// Initializes the model with saved card.
    ///
    /// - Parameter savedCard: Saved card.
    internal init(savedCard: CreateTokenSavedCard) {
        
        self.savedCard = savedCard
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case savedCard = "saved_card"
    }
}
