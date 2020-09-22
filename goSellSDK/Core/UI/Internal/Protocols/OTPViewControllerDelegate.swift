//
//  OTPViewControllerDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

internal protocol OTPViewControllerDelegate: ClassProtocol {
    
    func otpViewControllerResendButtonTouchUpInside(_ controller: OTPViewController)
    func otpViewController(_ controller: OTPViewController, didEnter code: String)
    func otpViewControllerDidCancel(_ controller: OTPViewController)
}
