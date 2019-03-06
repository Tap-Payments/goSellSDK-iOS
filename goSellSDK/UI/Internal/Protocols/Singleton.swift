//
//  Singleton.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol Singleton: ClassProtocol {
    
    static var shared: Self { get }
}
