//
//  Date+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension Date {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var month: Int {
        
        return self.get(.month)
    }
    
    internal var year: Int {
        
        return self.get(.year)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var currentCalendar: Calendar {
        
        return Calendar.current
    }
    
    // MARK: Methods
    
    private func get(_ component: Calendar.Component) -> Int {
        
        return self.currentCalendar.component(component, from: self)
    }
}
