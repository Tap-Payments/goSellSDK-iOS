//
//  SettingsDataManager+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum UIKit.UIInterface.UIUserInterfaceLayoutDirection

internal extension SettingsDataManager {
    
    internal var layoutDirection: UIUserInterfaceLayoutDirection {
        
        return Locale.characterDirection(forLanguage: SettingsDataManager.shared.localeIdentifier) == .leftToRight ? .leftToRight : .rightToLeft
    }
}
