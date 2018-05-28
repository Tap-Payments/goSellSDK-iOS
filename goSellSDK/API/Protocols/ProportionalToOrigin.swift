//
//  ProportionalToOrigin.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal protocol ProportionalToOrigin {
    
    var inUnitsOfOrigin: Decimal { get }
}

internal extension ProportionalToOrigin {
    
    internal func `in`(_ another: Self) -> Decimal {
        
        return another.inUnitsOfOrigin / self.inUnitsOfOrigin
    }
}
