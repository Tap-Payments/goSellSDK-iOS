//
//  SourcePaymentType.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum SourcePaymentType: String, Codable {
    
    case debitCard      = "DEBIT_CARD"
    case creditCard     = "CREDIT_CARD"
    case prepaidCard    = "PREPAID_CARD"
    case prepaidWallet  = "PREPAID_WALLET"
}
