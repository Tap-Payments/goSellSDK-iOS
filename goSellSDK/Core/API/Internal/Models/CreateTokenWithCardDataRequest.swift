//
//  CreateTokenWithCardDataRequest.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Request model for token creation with card data.
internal struct CreateTokenWithCardDataRequest: CreateTokenRequest {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Card to create token for.
    internal let card: CreateTokenCard
    
    internal let merchant: Merchant?
    
    internal let route: Route = .tokens
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Initializes the request with card.
    ///
    /// - Parameter card: Card.
    internal init(card: CreateTokenCard, merchant: Merchant?) {
        self.card = card
        self.merchant = merchant
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        case card = "card"
        case merchant = "merchant"
    }
}
