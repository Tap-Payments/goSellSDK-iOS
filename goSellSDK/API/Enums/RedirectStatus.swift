//
//  RedirectStatus.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum RedirectStatus: String, Codable {
    
    case pending    = "PENDING"
    case success    = "SUCCESS"
    case failed     = "FAILED"
}
