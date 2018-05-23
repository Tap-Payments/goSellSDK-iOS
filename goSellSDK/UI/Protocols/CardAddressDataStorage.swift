//
//  CardAddressDataStorage.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol CardAddressDataStorage: ClassProtocol {
    
    func cardInputData(for field: AddressField) -> Any?
}
