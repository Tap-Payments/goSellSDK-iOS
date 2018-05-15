//
//  PayButtonDelegate.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

@objc public protocol PayButtonDelegate: NSObjectProtocol {
    
    /// Asks the delegate to show payment view controller modally.
    ///
    /// - Parameter controller: Payment view controller.
    func showPaymentController(_ controller: PaymentViewController)
}
