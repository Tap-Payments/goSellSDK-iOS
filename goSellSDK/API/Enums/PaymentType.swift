//
//  PaymentType.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Payment type.
///
/// - card: Card payment type.
/// - web: Web payment type.
internal enum PaymentType: String, Decodable {
    
    case card = "card"
    case web = "web"
}
