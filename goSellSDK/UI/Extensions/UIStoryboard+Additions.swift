//
//  UIStoryboard+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIStoryboard.UIStoryboard

internal extension UIStoryboard {
    
    /// Reference to payment storyboard.
    internal static let goSellSDKPayment = UIStoryboard(name: UIStoryboardGoSellConstants.paymentStoryboardName, bundle: Bundle.goSellSDKResources)
    
    private struct UIStoryboardGoSellConstants {
        
        fileprivate static let paymentStoryboardName = "Payment"
        
        @available(*, unavailable) private init() {}
    }
}
