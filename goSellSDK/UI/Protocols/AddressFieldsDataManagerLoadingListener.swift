//
//  AddressFieldsDataManagerLoadingListener.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol AddressFieldsDataManagerLoadingListener: ClassProtocol {
    
    func addressFieldsDataManagerDidStartLoadingFormats()
    func addressFieldsDataManagerDidStopLoadingFormats()
}
