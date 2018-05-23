//
//  Country+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension Country {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Country display name.
    internal var displayName: String {
        
        let locale = Locale(identifier: goSellSDK.localeIdentifier)
        return locale.localizedString(forRegionCode: self.isoCode) ?? self.isoCode
    }
    
    internal static let all: [Country] = Locale.isoRegionCodes.compactMap { try? Country($0) }
}

// MARK: - Equatable
extension Country: Equatable {
    
    internal static func == (lhs: Country, rhs: Country) -> Bool {
        
        return lhs.isoCode.lowercased() == rhs.isoCode.lowercased()
    }
}

// MARK: - Filterable
extension Country: Filterable {
    
    internal func matchesFilter(_ filterText: String) -> Bool {
        
        if self.isoCode.containsIgnoringCase(filterText) {
            
            return true
        }
        if self.displayName.containsIgnoringCase(filterText) {
            
            return true
        }
        else {
            
            return false
        }
    }
}

// MARK: - ListValue
extension Country: ListValue {
    
    internal var displayValue: String {
        
        return self.displayName
    }
    
    internal var displayInTheListValue: String {
        
        return self.displayValue
    }
}
