//
//  PaymentDelegate.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment delegate.
@objc public protocol PaymentDelegate: class, NSObjectProtocol {
    
    /// Notifies the receiver that payment has succeed, passing `charge` and `payButton` which has initiated payment as arguments.
    ///
    /// - Parameters:
    ///   - charge: Successful charge object.
    ///   - payButton: Pay button which has initiated the payment.
    @objc optional func paymentSucceed(_ charge: Charge, payButton: PayButtonProtocol)
    
    /// Notifies the receiver that authorization has succeed, passing `authorize` and `payButton` which has initiated authorization as arguments.
    ///
    /// - Parameters:
    ///   - authorize: Successful authorization object.
    ///   - payButton: Pay button which has initiated the authorization.
    @objc optional func authorizationSucceed(_ authorize: Authorize, payButton: PayButtonProtocol)
    
    /// Notifies the receiver that charge has failed, passing `payButton` which has initiated the payment.
    ///
    /// - Parameters:
    ///   - charge: Charge that has failed (if reached the stage of charging).
    ///   - error: Error that has occured.
    ///   - payButton: Button which has initiated the payment.
    @objc optional func paymentFailed(with charge: Charge?, error: TapSDKError?, payButton: PayButtonProtocol)
    
    /// Notifies the receiver that authorization has failed, passing `payButton` which has initiated the authorization.
    ///
    /// - Parameters:
    ///   - authorization: Authorization that has failed (if reached the stage of authorization).
    ///   - error: Error that has occured.
    ///   - payButton: Button which has initiated the authorization.
    @objc optional func authorizationFailed(with authorization: Authorize?, error: TapSDKError?, payButton: PayButtonProtocol)
    
    /// Notifies the receiver that payment has been cancelled by the user.
    ///
    /// - Parameter payButton: Button which has initiated the payment/authorization
    @objc optional func paymentCancelled(_ payButton: PayButtonProtocol)
}
