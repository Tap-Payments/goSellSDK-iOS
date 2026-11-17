//
//  CreateTokenRequest.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal protocol CreateTokenRequest: Encodable {
    
    var route: Route { get }
}
