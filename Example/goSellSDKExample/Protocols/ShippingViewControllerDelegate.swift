//
//  ShippingViewControllerDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class goSellSDK.Shipping

internal protocol ShippingViewControllerDelegate: class {
    
    func shippingViewController(_ controller: ShippingViewController, didFinishWith shipping: Shipping)
}
