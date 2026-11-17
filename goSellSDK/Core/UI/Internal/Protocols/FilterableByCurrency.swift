//
//  FilterableByCurrency.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal protocol FilterableByCurrency {
    
    var supportedCurrencies: [Currency] { get }
}
