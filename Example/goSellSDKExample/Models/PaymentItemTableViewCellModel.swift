//
//  PaymentItemTableViewCellModel.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    goSellSDK.PaymentItem
import class    UIKit.UITableViewCell.UITableViewCell

internal class PaymentItemTableViewCellModel: TableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let paymentItem: PaymentItem
    
    internal override class var cellClass: UITableViewCell.Type {
        
        return PaymentItemTableViewCell.self
    }
    
    // MARK: Methods
    
    internal init(paymentItem: PaymentItem) {
        
        self.paymentItem = paymentItem
    }
}
