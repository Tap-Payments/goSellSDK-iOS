//
//  TapEncoder.swift
//  TapNetworkManager
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal protocol TapEncoder {

    associatedtype EncodedType

    func encode(_ data: Any) throws -> EncodedType
}
