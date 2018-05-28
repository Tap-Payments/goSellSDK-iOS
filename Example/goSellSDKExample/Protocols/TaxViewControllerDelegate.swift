//
//  TaxViewControllerDelegate.swift
//  goSellSDKExample
//
//  Created by Dennis Pashkov on 5/26/18.
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class goSellSDK.Tax

internal protocol TaxViewControllerDelegate: class {
    
    func taxViewController(_ controller: TaxViewController, didFinishWith tax: Tax)
}
