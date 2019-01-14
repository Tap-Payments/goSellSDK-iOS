//
//  ShippingViewControllerDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class goSellSDK.Shipping

internal protocol ShippingViewControllerDelegate: class {
    
    func shippingViewController(_ controller: ShippingViewController, didFinishWith shipping: Shipping)
}
