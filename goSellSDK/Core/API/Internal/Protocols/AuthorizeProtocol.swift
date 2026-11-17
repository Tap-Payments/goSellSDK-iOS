//
//  AuthorizeProtocol.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal protocol AuthorizeProtocol: ChargeProtocol {
    
    /// Authorize action.
    var authorizeAction: AuthorizeActionResponse { get }
}
