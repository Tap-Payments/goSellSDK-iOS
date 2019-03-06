//
//  CustomersListViewControllerDelegate.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class goSellSDK.Customer

internal protocol CustomersListViewControllerDelegate: class {
    
    func customersListViewController(_ controller: CustomersListViewController, didFinishWith customer: EnvironmentCustomer?)
}
