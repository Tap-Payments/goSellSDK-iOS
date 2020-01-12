//
//  CreateTokenWithApplePayRequest.swift
//  goSellSDK
//
//  Created by Osama Rabie on 11/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

/// Request model for token creation with apple pay data.
internal struct CreateTokenWithApplePayRequest: CreateTokenRequest {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Saved card details.
    internal let applePayToken: CreateTokenApplePay
    /// Card to create token for.
    internal let card: CreateTokenCard
    internal let route: Route = .tokens
    
    // MARK: Methods
    
    /// Initializes the model with applePayToken
    ///
    /// - Parameter applePayToken: applePayToken
    internal init(applePayToken: CreateTokenApplePay) {
        
        self.applePayToken = applePayToken
        self.card = CreateTokenCard(number: "", expirationMonth: "", expirationYear: "", cvc: "", cardholderName: "", address: nil)
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case applePayToken = ""
        case card = "card"
    }
}

