//
//  AppleTokenModel.swift
//  goSellSDK
//
//  Created by Osama Rabie on 11/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//


internal struct AppleTokenModel: Encodable,Decodable {
    
	
    
	
    // MARK: - Internal -
    // MARK: Properties  
    
    /// Card identifier.
    internal let version: String
    internal let data: String
    internal let signature: String
	internal let header: AppleTokenHeaderModel
    // MARK: Methods
    
    /// Initializes the model with decoded apple pay token
    ///
    /// - Parameters:
    ///   - appleToken: The base64 apple pay token
	internal init(version: String,data: String,signature: String,header: AppleTokenHeaderModel) {
        
        self.version = version
        self.data = data
		self.signature = signature
		self.header = header
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case version    = "version"
		case data   	= "data"
		case signature	= "signature"
		case header     = "header"
    }
}

