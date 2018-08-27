//
//  AddressType.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum AddressType: String, Codable {
    
    case residential    = "RESIDENTIAL"
    case commercial     = "COMMERCIAL"
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init?(_ stringValue: String) {
        
        let uppercased = stringValue.uppercased()
        self.init(rawValue: uppercased)
    }
}
