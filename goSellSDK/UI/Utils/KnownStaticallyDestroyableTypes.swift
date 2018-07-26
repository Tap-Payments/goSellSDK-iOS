//
//  KnownStaticallyDestroyableTypes.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias

internal struct KnownStaticallyDestroyableTypes {
    
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
        
        if self.delayedDestroyableButAlive.count > 0 {
            
            var pendingCompletions: [String: (String) -> Void] = [:]
            
            let localCompletion: TypeAlias.ArgumentlessClosure = {
                
                self.destroyAllDelayedDestroyableInstances(completion)
            }
            
            self.delayedDestroyableButAlive.forEach { (type) in
                
                let instanceDestroyCompletion: (String) -> Void =  { (identifier) in
                    
                    pendingCompletions.removeValue(forKey: identifier)
                    
                    if pendingCompletions.count == 0 {
                        
                        localCompletion()
                    }
                }
                
                let typeIdentifier = String(describing: type)
                
                pendingCompletions[typeIdentifier] = instanceDestroyCompletion
                
                type.destroyInstance {
                    
                    instanceDestroyCompletion(typeIdentifier)
                }
            }
        }
        else {
            
            completion()
        }
    }
    
    private static var knownImmediateDestroyableTypes: [ImmediatelyDestroyable.Type] = []
    private static var knownDelayedDestroyableTypes: [DelayedDestroyable.Type] = []
    
    private static var immediatelyDestroyableButAlive: [ImmediatelyDestroyable.Type] {
        
        return self.knownImmediateDestroyableTypes.filter { $0.hasAliveInstance }
    }
    
    private static var delayedDestroyableButAlive: [DelayedDestroyable.Type] {
        
        return self.knownDelayedDestroyableTypes.filter { $0.hasAliveInstance }
    }
    
    @available(*, unavailable) private init() {}
    
    private static func addImmediateDestroyable(_ type: ImmediatelyDestroyable.Type) {
        
        self.knownImmediateDestroyableTypes.append(type)
    }
    
    private static func addDelayedDestroyable(_ type: DelayedDestroyable.Type) {
        
        self.knownDelayedDestroyableTypes.append(type)
    }
}
