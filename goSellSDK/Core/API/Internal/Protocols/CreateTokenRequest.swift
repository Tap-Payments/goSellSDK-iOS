//
//  CreateTokenRequest.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal protocol CreateTokenRequest: Encodable {
    
    var route: Route { get }
}
