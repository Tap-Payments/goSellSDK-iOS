//
//  PaymentStatus.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum PaymentStatus {
    
    case cancelled
    case successfulCharge(Charge)
    case successfulAuthorize(Authorize)
    case failure
}
