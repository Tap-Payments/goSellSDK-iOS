//
//  RetrieveCardsResponse.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Retrieve cards response model.
@objcMembers public final class RetrieveCardsResponse: NSObject, Decodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// String representing the object’s type. Objects of the same type share the same value.
    public private(set) var object: String?
    
    /// Defines if there are more cards to load.
    public private(set) var hasMore: Bool = false
    
    /// Cards.
    public private(set) var cards: [Card] = []
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case object
        case hasMore = "has_more"
        case cards = "data"
    }
}
