//
//  ExpirationDate+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension ExpirationDate {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Current date.
    internal static var current: ExpirationDate {
        
        let currentDate = Date()
        return ExpirationDate(month: currentDate.month, year: currentDate.year)
    }
    
    /// Month string.
    internal var monthString: String {
        
        return String(format: "%02d", locale: Locale.enUS, arguments: [self.month])
    }
    
    /// Year string.
    internal var yearString: String {
        
        return String(format: "%02d", locale: Locale.enUS, arguments: [self.year % 100])
    }
    
    /// Readable input field representation.
    internal var inputFieldRepresentation: String {
        
        return "\(self.monthString)/\(self.yearString)"
    }
    
    /// API representation string.
    internal var apiRepresentation: String {
        
        return "\(self.yearString)\(self.monthString)"
    }
}
