//
//  Authenticatable.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal protocol Authenticatable: Decodable {
    
    /// Unique object identifier.
    var identifier: String { get }
    
    /// Charge authentication if required.
    var authentication: Authentication? { get }
    
    /// Authentication route.
    static var authenticationRoute: Route { get }
}
