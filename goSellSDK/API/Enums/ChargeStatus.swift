//
//  ChargeStatus.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum ChargeStatus: String, Decodable {
    
    case initiated      = "INITIATED"
    case otpRequired    = "OTP_REQUIRED"
    case inProgress     = "IN_PROGRESS"
    case cancelled      = "CANCELLED"
    case failed         = "FAILED"
    case declined       = "DECLINED"
    case restricted     = "RESTRICTED"
    case captured       = "CAPTURED"
    case void           = "VOID"
}
