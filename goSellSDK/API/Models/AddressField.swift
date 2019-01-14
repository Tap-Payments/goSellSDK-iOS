//
//  AddressField.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Address field model.
internal struct AddressField: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Field name.
    internal let name: String
    
    /// Field input type.
    internal let type: AddressFieldInputType
    
    /// Placeholder text.
    internal let placeholder: String
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case name           = "name"
        case type           = "type"
        case placeholder    = "place_holder"
    }
}
