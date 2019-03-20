//
//  FilterableByCurrency.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal protocol FilterableByCurrency {
    
    var supportedCurrencies: [Currency] { get }
}
