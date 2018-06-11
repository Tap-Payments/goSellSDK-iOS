//
//  PaymentItemViewControllerDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class goSellSDK.PaymentItem

internal protocol PaymentItemViewControllerDelegate: class {
    
    func paymentItemViewController(_ controller: PaymentItemViewController, didFinishWith item: PaymentItem)
}
