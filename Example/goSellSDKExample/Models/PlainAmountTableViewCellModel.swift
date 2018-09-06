//
//  PlainAmountTableViewCellModel.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct Foundation.NSDecimal.Decimal

internal class PlainAmountTableViewCellModel: TableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let amount: Decimal
    
    // MARK: Methods
    
    internal init(amount: Decimal) {
        
        self.amount = amount
    }
}
