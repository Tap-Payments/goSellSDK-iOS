//
//  CreateTokenWithApplePayDataRequest.swift
//  goSellSDK
//
//  Created by Osama Rabie on 07/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation


/// Request model for token creation with apple payment data
internal struct CreateTokenWithApplePayDataRequest: CreateTokenRequest {
	// MARK: - Internal -
    // MARK: Properties
    
    /// Saved card details.
    internal let applePaymentData: CreateTokenApplePayment
    
    internal let route: Route = .tokens
    
    // MARK: Methods
    
    /// Initializes the model with saved card.
    ///
    /// - Parameter applePaymentData: The apple payment data create token request
    internal init(applePaymentData: CreateTokenApplePayment) {
        
        self.applePaymentData = applePaymentData
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case applePaymentData = "apple_payment_data"
    }
}
