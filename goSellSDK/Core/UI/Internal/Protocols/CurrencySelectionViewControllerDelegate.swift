//
//  CurrencySelectionViewControllerDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

internal protocol CurrencySelectionViewControllerDelegate: ClassProtocol {
    
    func currencySelectionViewControllerDidFinish(with currency: AmountedCurrency, changed: Bool)
}
