//
//  Country+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension Country {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Country display name.
    internal var displayName: String {
        
        let locale = Locale(identifier: goSellSDK.localeIdentifier)
        return locale.localizedString(forRegionCode: self.isoCode) ?? self.isoCode
    }
}
