//
//  PaymentDelegate.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment delegate.
@objc public protocol PaymentDelegate: class, NSObjectProtocol {
    
    /// Notifies the receiver that payment has succeed, passing `charge` as an argument.
    ///
    /// - Parameter charge: Successful charge object.
    @objc optional func paymentSuccess(_ charge: Charge)
    
    /// Notifies the receiver that authorization has succeed, passing `authorize` as an argument.
    ///
    /// - Parameter authorize: Successful authorization object.
    @objc optional func authorizeSuccess(_ authorize: Authorize)
    
    /// Notifies the receiver that payment has failed.
    func paymentFailure()
    
    /// Notifies the receiver that payment has been cancelled by the user.
    func paymentCancel()
}
