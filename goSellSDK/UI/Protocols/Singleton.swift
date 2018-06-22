//
//  Singleton.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol StaticlyDestroyable: ClassProtocol {
    
    static var hasAliveInstance: Bool { get }
    static func destroyInstance()
}

internal protocol Singleton: StaticlyDestroyable {
    
    static var shared: Self { get }
    
}

internal struct KnownSingletonTypes {
    
    internal static func add(_ type: StaticlyDestroyable.Type) {
        
        self.knownSingletonTypes.append(type)
    }
    
    internal static func destroyAllInstances() {
        
        var alive = self.typesWithAliveInstance
        typesWithAliveInstance.forEach { $0.destroyInstance() }
        
        alive = self.typesWithAliveInstance
        if alive.count > 0 {
            
            self.destroyAllInstances()
        }
    }
    
    private static var knownSingletonTypes: [StaticlyDestroyable.Type] = []
    
    private static var typesWithAliveInstance: [StaticlyDestroyable.Type] {
        
        return self.knownSingletonTypes.compactMap { $0.hasAliveInstance ? $0 : nil }
    }
    
    @available(*, unavailable) private init() {}
}
