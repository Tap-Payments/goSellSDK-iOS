//
//  DeleteCardResponse.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct DeleteCardResponse: Identifiable, Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let isDeleted: Bool
    internal var identifier: String?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case isDeleted  = "deleted"
        case identifier = "id"
    }
}
