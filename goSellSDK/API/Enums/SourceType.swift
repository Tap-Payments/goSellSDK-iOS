//
//  SourceType.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum SourceType: String, Codable {
    
    case cardPresent    = "CARD_PRESENT"
    case cardNotPresent = "CARD_NOT_PRESENT"
}
