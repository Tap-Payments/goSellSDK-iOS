//
//  PaymentDelegate.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment delegate.
@objc public protocol PaymentDelegate: class, NSObjectProtocol {
    
    /// Notifies the receiver that payment has finished successfully.
    ///
    /// - Parameter customerID: Customer identifier for reuse.
    func paymentSuccess(_ customerID: String)
    
    /// Notifies the receiver that payment has failed.
    func paymentFailure()
    
    /// Notifies the receiver that payment has been cancelled by the user.
    func paymentCancel()
}
