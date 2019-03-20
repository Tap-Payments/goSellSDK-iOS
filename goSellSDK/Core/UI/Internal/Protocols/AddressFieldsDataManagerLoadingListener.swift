//
//  AddressFieldsDataManagerLoadingListener.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol AddressFieldsDataManagerLoadingListener: ClassProtocol {
    
    func addressFieldsDataManagerDidStartLoadingFormats()
    func addressFieldsDataManagerDidStopLoadingFormats()
}
