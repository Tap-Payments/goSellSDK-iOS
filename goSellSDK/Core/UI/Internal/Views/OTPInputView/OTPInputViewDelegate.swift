//
//  OTPInputViewDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import protocol TapAdditionsKitV2.ClassProtocol

internal protocol OTPInputViewDelegate: ClassProtocol {
    
    func otpInputView(_ otpInputView: OTPInputView, inputStateChanged valid: Bool, wholeOTPAtOnce: Bool)
}
