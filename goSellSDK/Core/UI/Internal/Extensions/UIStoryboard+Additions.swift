//
//  UIStoryboard+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    UIKit.UIStoryboard.UIStoryboard

internal extension UIStoryboard {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Reference to payment storyboard.
    static let goSellSDKPayment = UIStoryboard(name: UIStoryboardGoSellConstants.paymentStoryboardName, bundle: .goSellSDKResources)
    
    /// Reference to popups storyboard.
    static let goSellSDKPopups = UIStoryboard(name: UIStoryboardGoSellConstants.popupsStoryboardName, bundle: .goSellSDKResources)
    
    // MARK: - Private -
    
    private struct UIStoryboardGoSellConstants {
        
        fileprivate static let paymentStoryboardName    = "Payment"
        fileprivate static let popupsStoryboardName     = "Popups"
        
        //@available(*, unavailable) private init() { }
    }
}
