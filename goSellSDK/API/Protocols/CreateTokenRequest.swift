//
//  CreateTokenRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal protocol CreateTokenRequest: Encodable {
    
    var route: Route { get }
}
