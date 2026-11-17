//
//  BillingAddressFormat.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal struct BillingAddressFormat: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Address format name.
    internal let name: AddressFormat
    
    /// Address fields.
    internal let fields: [BillingAddressField]
}
