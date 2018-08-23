//
//  AuthorizeActionStatus.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public enum AuthorizeActionStatus: String, Decodable {
    
    case pending    = "PENDING"
    case scheduled  = "SCHEDULED"
    case captured   = "CAPTURED"
    case failed     = "FAILED"
    case declined   = "DECLINED"
    case void       = "VOID"
}
