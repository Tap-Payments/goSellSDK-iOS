//
//  TapNetworkError.swift
//  TapNetworkManager
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public enum TapNetworkError: Error {

    case internalError
    case serializationError(TapSerializationError)
    case wrongURL(String)
}

public enum TapSerializationError {

    case wrongData
}
