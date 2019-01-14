//
//  CountrySelectionViewControllerDelegate.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol CountrySelectionViewControllerDelegate: ClassProtocol {
    
    func countriesSelectionViewControllerDidFinish(with country: Country, changed: Bool)
}
