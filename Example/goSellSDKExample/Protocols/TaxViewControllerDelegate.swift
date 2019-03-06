//
//  TaxViewControllerDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class goSellSDK.Tax

internal protocol TaxViewControllerDelegate: class {
    
    func taxViewController(_ controller: TaxViewController, didFinishWith tax: Tax)
}
