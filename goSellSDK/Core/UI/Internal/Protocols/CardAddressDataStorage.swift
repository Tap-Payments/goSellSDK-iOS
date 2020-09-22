//
//  CardAddressDataStorage.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

internal protocol CardAddressDataStorage: ClassProtocol {
    
    func cardInputData(for field: BillingAddressField) -> Any?
}
