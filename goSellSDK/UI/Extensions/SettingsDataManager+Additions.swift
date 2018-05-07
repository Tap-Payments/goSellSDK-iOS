//
//  SettingsDataManager+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension SettingsDataManager {
    
    internal var layoutDirection: UIUserInterfaceLayoutDirection {
        
        return Locale.characterDirection(forLanguage: goSellSDK.localeIdentifier) == .leftToRight ? .leftToRight : .rightToLeft
    }
}
