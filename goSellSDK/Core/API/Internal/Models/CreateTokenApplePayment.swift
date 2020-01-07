//
//  CreateTokenApplePayment.swift
//  goSellSDK
//
//  Created by Osama Rabie on 07/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
internal struct CreateTokenApplePayment: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Apple payment data base 64 encoded string
    internal let applePayDataToken: String
	
    
    // MARK: Methods
    
    /// Initializes the model with card identifier and customer identifier.
    ///
    /// - Parameters:
    ///   - applePayDataToken: The token data returned from Apple Pay Kit upon customer authorisation
    internal init(applePayDataToken: String) {
        self.applePayDataToken = applePayDataToken
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        case applePayDataToken     = "apple_pay_data_token"
    }
}
