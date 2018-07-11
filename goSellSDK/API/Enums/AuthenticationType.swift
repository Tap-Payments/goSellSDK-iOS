//
//  AuthenticationType.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum AuthenticationType: String, Codable {
    
    case otp        = "OTP"
    case biometrics = "BIOMETRICS"
}
