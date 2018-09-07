//
//  PlainAmountTableViewCellModel.swift
//  goSellSDKExample
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct Foundation.NSDecimal.Decimal

internal protocol AmountChangeObserver {
    
    func amountChanged(_ amount: Decimal)
}

internal class PlainAmountTableViewCellModel: TableViewCellModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let amountChangeObsever: AmountChangeObserver
    
    internal var amountString: String
    
    internal var amount: Decimal {
        
        return self.amountString.decimalValue ?? 0
    }
    
    // MARK: Methods
    
    internal init(amountString: String, changeObserver: AmountChangeObserver) {
        
        self.amountString = amountString
        self.amountChangeObsever = changeObserver
    }
}

// MARK: - PlainAmountTableViewCellTextChangeListener
extension PlainAmountTableViewCellModel: PlainAmountTableViewCellTextChangeListener {
    
    func textChanged(_ text: String) {
        
        self.amountString = text
        self.amountChangeObsever.amountChanged(self.amount)
    }
}
