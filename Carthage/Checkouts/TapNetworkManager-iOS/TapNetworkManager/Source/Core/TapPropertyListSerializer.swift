//
//  TapPropertyListSerializer.swift
//  TapNetworkManager
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct Foundation.NSData.Data
import class Foundation.NSPropertyList.PropertyListSerialization

internal class TapPropertyListSerializer {

    // MARK: - Internal -
    // MARK: Properties

    /// Shared instance.
    internal static let shared = TapPropertyListSerializer()

    // MARK: - Private -
    // MARK: Methods

    private init() {}
}

extension TapPropertyListSerializer: TapEncoder {

    internal typealias EncodedType = Data

    internal func encode(_ data: Any) throws -> Data {

        let allFormats: [PropertyListSerialization.PropertyListFormat] = [.xml, .binary, .openStep]

        for format in allFormats {

            if PropertyListSerialization.propertyList(data, isValidFor: format) {

                return try PropertyListSerialization.data(fromPropertyList: data, format: format, options: 0)
            }
        }

        throw TapNetworkError.serializationError(.wrongData)
    }
}

extension TapPropertyListSerializer: TapDecoder {

    internal typealias DecodedType = Any

    internal func decode(_ data: Any) throws -> Any {

        guard let d = data as? Data else {

            throw TapNetworkError.serializationError(.wrongData)
        }

        return try PropertyListSerialization.propertyList(from: d, options: [], format: nil)
    }
}
