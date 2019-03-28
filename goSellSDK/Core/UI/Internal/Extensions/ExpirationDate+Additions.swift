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
    static var current: ExpirationDate {
        
        let currentDate = Date()
        return ExpirationDate(month: currentDate.tap_month, year: currentDate.tap_year)
    }
    
    /// Month string.
    var monthString: String {
        
        return String(format: "%02d", locale: .tap_enUS, arguments: [self.month])
    }
    
    /// Year string.
    var yearString: String {
        
        return String(format: "%02d", locale: .tap_enUS, arguments: [self.year % 100])
    }
    
    /// Readable input field representation.
    var inputFieldRepresentation: String {
        
        return "\(self.monthString)/\(self.yearString)"
    }
    
    /// API representation string.
    var apiRepresentation: String {
        
        return "\(self.yearString)\(self.monthString)"
    }
}
