//
//  ListValue.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// List value protocol.
internal protocol ListValue: Filterable {
    
    var displayValue: String { get }
    var displayInTheListValue: String { get }
}
