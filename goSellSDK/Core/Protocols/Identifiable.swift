//
//  Identifiable.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// All models that have identifier are conforming to this protocol.
public protocol Identifiable {
    
    // MARK: Properties
    
    /// Unique identifier of an object.
    var identifier: String? { get }
}
