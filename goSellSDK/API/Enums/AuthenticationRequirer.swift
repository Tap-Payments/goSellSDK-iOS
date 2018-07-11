//
//  AuthenticationRequirer.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum AuthenticationRequirer: String, Decodable {
    
    case provider   = "PROVIDER"
    case merchant   = "MERCHANT"
    case cardholder = "CARDHOLDER"
}
