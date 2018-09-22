//
//  CustomerViewControllerDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class goSellSDK.Customer

internal protocol CustomerViewControllerDelegate: class {
    
    func customerViewController(_ controller: CustomerViewController, didFinishWith customer: EnvironmentCustomer)
}
