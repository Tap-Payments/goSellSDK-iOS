//
//  Filterable.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal protocol Filterable {
    
    func matchesFilter(_ filterText: String) -> Bool
}
