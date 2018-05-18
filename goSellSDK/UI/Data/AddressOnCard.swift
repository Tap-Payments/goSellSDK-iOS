//
//  AddressOnCard.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Structure handling address on card.
internal struct AddressOnCard {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Country.
    internal var country: Country?
    
    /// City.
    internal var city: String?
    
    /// State.
    internal var state: String?
    
    /// Zip code.
    internal var zipCode: String?
    
    /// Line 1.
    internal var line1: String?
    
    /// Line 2.
    internal var line2: String?
}
