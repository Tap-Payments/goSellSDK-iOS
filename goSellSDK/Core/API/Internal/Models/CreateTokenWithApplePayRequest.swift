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
    
    internal let route: Route = .tokens
    
    // MARK: Methods
    
    /// Initializes the model with applePayToken
    ///
    /// - Parameter applePayToken: applePayToken
    internal init(applePayToken: CreateTokenApplePay) {
        
        self.applePayToken = applePayToken
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case applePayToken = ""
    }
}

