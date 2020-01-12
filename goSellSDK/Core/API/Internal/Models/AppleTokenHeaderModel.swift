//
//  AppleTokenHeaderModel.swift
//  goSellSDK
//
//  Created by Osama Rabie on 11/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//


internal struct AppleTokenHeaderModel: Encodable,Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Card identifier.
    internal let ephemeralPublicKey: String
    internal let publicKeyHash: String
    internal let transactionId: String
    // MARK: Methods
    
    /// Initializes the model with decoded apple pay token
    ///
    /// - Parameters:
    ///   - appleToken: The base64 apple pay token
    internal init(ephemeralPublicKey: String,publicKeyHash: String,transactionId: String) {
        
        self.ephemeralPublicKey = ephemeralPublicKey
        self.publicKeyHash = publicKeyHash
		self.transactionId = transactionId
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case ephemeralPublicKey     = "ephemeralPublicKey"
        case publicKeyHash     		= "publicKeyHash"
		case transactionId 			= "transactionId"
    }
}


