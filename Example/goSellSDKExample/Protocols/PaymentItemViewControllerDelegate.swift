//
//  PaymentItemViewControllerDelegate.swift
//  goSellSDKExample
//
//  Created by Dennis Pashkov on 5/26/18.
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class goSellSDK.PaymentItem

internal protocol PaymentItemViewControllerDelegate: class {
    
    func paymentItemViewController(_ controller: PaymentItemViewController, didFinishWith item: PaymentItem)
}
