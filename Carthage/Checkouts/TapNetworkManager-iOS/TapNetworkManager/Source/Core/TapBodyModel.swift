//
//  TapBodyModel.swift
//  TapNetworkManager
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Tap body model.
public struct TapBodyModel {

    public var serializationType: TapSerializationType = .json

    public var body: [String: Any]

    public init(body: [String: Any], serializationType: TapSerializationType = .json) {

        self.serializationType = serializationType
        self.body = body
    }
}
