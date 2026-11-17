//
//  DeleteCardResponse.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal struct DeleteCardResponse: IdentifiableWithString, Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let isDeleted: Bool
    internal let identifier: String
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case isDeleted  = "deleted"
        case identifier = "id"
    }
}
