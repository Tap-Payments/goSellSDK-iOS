//
//  DeleteCardResponse.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Delete card response model.
@objcMembers public class DeleteCardResponse: NSObject, Decodable, Identifiable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns true on success.
    public private(set) var isDeleted: Bool = false
    
    /// The ID of the deleted card.
    public private(set) var identifier: String?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case isDeleted = "deleted"
        case identifier = "id"
    }
}
