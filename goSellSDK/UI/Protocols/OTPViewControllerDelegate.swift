//
//  OTPViewControllerDelegate.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol OTPViewControllerDelegate: ClassProtocol {
    
    func otpViewControllerResendButtonTouchUpInside(_ controller: OTPViewController)
    func otpViewController(_ controller: OTPViewController, didEnter code: String)
}
