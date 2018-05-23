//
//  AddressField.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct AddressField: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Field input type.
    internal let inputType: AddressFieldInputType
    
    /// Field placeholder
    internal let placeholder: String
    
    
    /// Defines if the field is required
    internal let isRequired: Bool
    
    /// Field input order.
    internal let inputOrder: Int
    
    /// Field display order.
    internal let displayOrder: Int
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case inputType = "input_type"
        case placeholder = "placeholder"
        case isRequired = "required"
        case inputOrder = "order_by"
        case displayOrder = "display_order"
    }
}
