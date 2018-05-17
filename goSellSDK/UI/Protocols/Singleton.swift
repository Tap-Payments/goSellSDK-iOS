//
//  Singleton.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol StaticlyDestroyable: ClassProtocol {
    
    static func destroyInstance()
}

internal protocol Singleton: StaticlyDestroyable {
    
    static var shared: Self { get }
    
}

internal struct KnownSingletonTypes {
    
    internal static func add(_ type: StaticlyDestroyable.Type) {
        
        self.knownSingletonTypes.append(type)
    }
    
    internal static func destroyAll() {
        
        self.knownSingletonTypes.forEach { $0.destroyInstance() }
    }
    
    private static var knownSingletonTypes: [StaticlyDestroyable.Type] = []
    
    @available(*, unavailable) private init() {}
}
