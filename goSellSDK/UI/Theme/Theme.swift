//
//  Theme.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public enum Theme {
    
    case light
    
    // MARK: - Internal -
    
    internal static var current: Theme {
        
        return PaymentDataManager.shared.currentTheme
    }
}
