//
//  PaymentItemTableViewCellModel.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    goSellSDK.PaymentItem

internal class PaymentItemTableViewCellModel: TableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let paymentItem: PaymentItem
    
    // MARK: Methods
    
    internal init(paymentItem: PaymentItem) {
        
        self.paymentItem = paymentItem
    }
}
