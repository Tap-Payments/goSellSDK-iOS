//
//  Theme.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Theme.
public enum Theme {
    
    /// Light theme.
    case light
    
    // MARK: - Internal -
    
    internal static var current: Theme {
        
        return PaymentDataManager.shared.currentTheme
    }
}
