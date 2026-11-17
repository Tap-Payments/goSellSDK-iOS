//
//  Authenticatable.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal protocol Authenticatable: Decodable {
    
    /// Unique object identifier.
    var identifier: String { get }
    
    /// Charge authentication if required.
    var authentication: Authentication? { get }
    
    /// Authentication route.
    static var authenticationRoute: Route { get }
}
