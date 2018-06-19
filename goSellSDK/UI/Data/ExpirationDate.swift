//
//  ExpirationDate.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Expiration date structure.
internal struct ExpirationDate {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Returns current date.
    internal static var current: ExpirationDate {
        
        let currentDate = Date()
        return ExpirationDate(month: currentDate.month, year: currentDate.year % 100)
    }
    
    internal var monthString: String {
        
        return String(format: "%02d", locale: Locale.enUS, arguments: [self.month])
    }
    
    internal var yearString: String {
        
        return String(format: "%02d", locale: Locale.enUS, arguments: [self.year])
    }
    
    /// Month.
    internal var month: Int
    
    /// Year.
    internal var year: Int
    
    /// Readable input field representation.
    internal var inputFieldRepresentation: String {
        
        return "\(self.monthString)/\(self.yearString)"
    }
    
    /// API representation string.
    internal var apiRepresentation: String {
        
        return "\(self.yearString)\(self.monthString)"
    }
    
    // MARK: Methods
    
    /// Initialized expiration date with month and year.
    internal init(month: Int, year: Int) {
        
        self.month = month
        self.year = year
    }
}
