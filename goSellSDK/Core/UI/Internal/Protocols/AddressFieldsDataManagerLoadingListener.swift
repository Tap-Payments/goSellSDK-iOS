//
//  AddressFieldsDataManagerLoadingListener.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

internal protocol AddressFieldsDataManagerLoadingListener: ClassProtocol {
    
    func addressFieldsDataManagerDidStartLoadingFormats()
    func addressFieldsDataManagerDidStopLoadingFormats()
}
