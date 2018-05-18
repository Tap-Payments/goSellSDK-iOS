//
//  CardAddressInputListener.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

/// Protocol to listen to input changes.
internal protocol CardAddressInputListener: ClassProtocol {
    
    /// Notifies the receiver that input has changed in a given field.
    ///
    /// - Parameters:
    ///   - field: Input field.
    ///   - value: Input value.
    func inputChanged(in field: AddressField, to value: Any?)
}
