//
//  FilterableByCurrency.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal protocol FilterableByCurrency {
    
    var supportedCurrencies: [Currency] { get }
}
