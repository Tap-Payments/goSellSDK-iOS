//
//  KnownStaticallyDestroyableTypes.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct TapAdditionsKitV2.TypeAlias

internal struct KnownStaticallyDestroyableTypes {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func add(_ type: StaticlyDestroyable.Type) {
        
        if let immediatelyDestroyableType = type as? ImmediatelyDestroyable.Type {
            
            self.addImmediateDestroyable(immediatelyDestroyableType)
        }
        
        if let delayedDestroyableType = type as? DelayedDestroyable.Type {
            
            self.addDelayedDestroyable(delayedDestroyableType)
        }
    }
    
    internal static func destroyAllInstances(_ completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        self.destroyAllDelayedDestroyableInstances {
            
            self.destroyAllImmediateDestroyableInstances()
            completion?()
        }
    }
    
    internal static func destroyAllImmediateDestroyableInstances() {
        
        self.immediatelyDestroyableButAlive.forEach { $0.destroyInstance() }
        
        if self.immediatelyDestroyableButAlive.count > 0 {
            
            self.destroyAllImmediateDestroyableInstances()
        }
    }
    
    internal static func destroyAllDelayedDestroyableInstances(_ completion: @escaping TypeAlias.ArgumentlessClosure) {
        
        guard self.delayedDestroyableButAlive.count > 0 else {
            
            completion()
            return
        }
        
        self.isDestroyingDelayedDestroyable = true
        self.destroyDelayedDestroyableCompletion = completion
        
        self.delayedDestroyableButAlive.forEach { (type) in
            
            type.destroyInstance(nil)
        }
    }
    
    internal static func delayedDestroyableInstanceDestroyed() {
        
        if self.delayedDestroyableButAlive.count == 0 && self.isDestroyingDelayedDestroyable {
            
            self.isDestroyingDelayedDestroyable = false
            self.destroyDelayedDestroyableCompletion?()
            self.destroyDelayedDestroyableCompletion = nil
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private static var knownImmediateDestroyableTypes: [ImmediatelyDestroyable.Type] = []
    private static var knownDelayedDestroyableTypes: [DelayedDestroyable.Type] = []
    
    private static var immediatelyDestroyableButAlive: [ImmediatelyDestroyable.Type] {
        
        return self.knownImmediateDestroyableTypes.filter { $0.hasAliveInstance }
    }
    
    private static var delayedDestroyableButAlive: [DelayedDestroyable.Type] {
        
        return self.knownDelayedDestroyableTypes.filter { $0.hasAliveInstance }
    }
    
    private static var isDestroyingDelayedDestroyable = false
    private static var destroyDelayedDestroyableCompletion: TypeAlias.ArgumentlessClosure?
    
    // MARK: Methods
    
    //@available(*, unavailable) private init() { }
    
    private static func addImmediateDestroyable(_ type: ImmediatelyDestroyable.Type) {
        
        self.knownImmediateDestroyableTypes.append(type)
    }
    
    private static func addDelayedDestroyable(_ type: DelayedDestroyable.Type) {
        
        self.knownDelayedDestroyableTypes.append(type)
    }
}
