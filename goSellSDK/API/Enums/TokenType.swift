//
//  TokenType.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Token type.
///
/// - card: Card token.
/// - savedCard: Saved card token.
internal enum TokenType: String, Decodable {
    
    case card       = "CARD"
    case savedCard  = "SAVED_CARD"
}
