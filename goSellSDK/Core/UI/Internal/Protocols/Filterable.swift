//
//  Filterable.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal protocol Filterable {
    
    func matchesFilter(_ filterText: String) -> Bool
}
