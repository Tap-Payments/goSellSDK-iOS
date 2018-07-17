//
//  BillingAddressFormat.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct BillingAddressFormat: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Address format name.
    internal let name: AddressFormat
    
    /// Address fields.
    internal let fields: [BillingAddressField]
}
