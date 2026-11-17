//
//  ListValue.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
/// List value protocol.
internal protocol ListValue: Filterable {
    
    var displayValue: String { get }
    var displayInTheListValue: String { get }
}
