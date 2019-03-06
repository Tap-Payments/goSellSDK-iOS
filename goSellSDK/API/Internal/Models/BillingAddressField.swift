//
//  BillingAddressField.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Address field.
internal struct BillingAddressField: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Address field name.
    internal let name: String
    
    /// Defines if the field is required
    internal let isRequired: Bool
    
    /// Field input order.
    internal let inputOrder: Int
    
    /// Field display order.
    internal let displayOrder: Int
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case name           = "name"
        case isRequired     = "required"
        case inputOrder     = "order_by"
        case displayOrder   = "display_order"
    }
}
