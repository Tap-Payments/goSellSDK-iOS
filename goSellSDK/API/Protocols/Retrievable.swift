//
//  Retrievable.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal protocol Retrievable: IdentifiableWithString, Decodable {
    
    static var retrieveRoute: Route { get }
}
