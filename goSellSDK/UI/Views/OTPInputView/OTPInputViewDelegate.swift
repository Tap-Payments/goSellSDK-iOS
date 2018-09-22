//
//  OTPInputViewDelegate.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol OTPInputViewDelegate: ClassProtocol {
    
    func otpInputView(_ otpInputView: OTPInputView, inputStateChanged valid: Bool, wholeOTPAtOnce: Bool)
}
