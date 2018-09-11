//
//  CustomersListViewControllerDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class goSellSDK.Customer

internal protocol CustomersListViewControllerDelegate: class {
    
    func customersListViewController(_ controller: CustomersListViewController, didFinishWith customer: Customer?)
}
