//
//  AuthenticationStatus.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum AuthenticationStatus: String, Decodable {
    
    case initiated          = "INITIATED"
    case authenticated      = "AUTHENTICATED"
    case notAuthenticated   = "NOT_AUTHENTICATED"
    case abandoned          = "ABANDONED"
    case failed             = "FAILED"
}
