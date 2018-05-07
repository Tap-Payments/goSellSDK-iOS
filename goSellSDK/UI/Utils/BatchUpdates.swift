//
//  BatchUpdates.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct BatchUpdates {
    
    internal let deleted: [Int]
    internal let inserted: [Int]
    internal let moved: [(Int, Int)]
    
    internal init<T: Equatable>(oldValues: [T], newValues: [T]) {
        
        var deleted = [Int]()
        var moved = [(Int, Int)]()
        var remainingNewValues = newValues.enumerated().map { (element: $0.element, offset: $0.offset, alreadyFound: false) }
        
        outer: for oldValue in oldValues.enumerated() {
            
            for newValue in remainingNewValues {
                
                if !newValue.alreadyFound && (oldValue.element == newValue.element)  {
                    
                    if oldValue.offset != newValue.offset {
                        
                        moved.append((oldValue.offset, newValue.offset))
                    }
                    
                    remainingNewValues[newValue.offset].alreadyFound = true
                    continue outer
                }
            }
            
            deleted.append(oldValue.offset)
        }
        
        let inserted = (remainingNewValues.filter { !$0.alreadyFound }).map { $0.offset }
        
        self.deleted = deleted
        self.inserted = inserted
        self.moved = moved
    }
}
