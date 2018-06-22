//
//  CurrencyFormatter.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import func TapSwiftFixes.synchronized

/// Currency Formatter utility class.
internal final class CurrencyFormatter {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Formats amounted currency into readable string in specified locale.
    ///
    /// - Parameters:
    ///   - amountedCurrency: Amounted currency.
    ///   - locale: Locale.
    internal func format(_ amountedCurrency: AmountedCurrency, with locale: Locale = .enUS, displayCurrency: Bool = true) -> String {
        
        return synchronized(self.currencyFormatter) {
            
            self.currencyFormatter.locale = locale
            self.currencyFormatter.currencyCode = amountedCurrency.currency.isoCode.uppercased()
            
            self.currencyFormatter.positiveFormat = nil
            self.currencyFormatter.negativeFormat = nil
            
            let positiveFormat = self.currencyFormatter.positiveFormat
            let negativeFormat = self.currencyFormatter.negativeFormat
            
            let currencySymbol = displayCurrency ? amountedCurrency.currencySymbol : String.empty
            
            self.currencyFormatter.locale = Locale.enUS
            
            self.currencyFormatter.positiveFormat = positiveFormat
            self.currencyFormatter.negativeFormat = negativeFormat
            self.currencyFormatter.currencySymbol = currencySymbol
            
            let decimalAmount = amountedCurrency.amount as NSDecimalNumber
            
            if let amountString = self.currencyFormatter.string(from: decimalAmount) {
                
                return amountString
            }
            else {
                
                return currencySymbol + decimalAmount.stringValue
            }
        }
    }
    
    internal func localizedCurrencySymbol(for currencyCode: String, locale: Locale = .enUS) -> String {
        
        var currencySymbol = (locale as NSLocale).displayName(forKey: .currencySymbol, value: currencyCode) ?? currencyCode
        self.optionallyHardcodeCurrencySymbol(&currencySymbol)
        
        return currencySymbol
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private lazy var currencyFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter(locale: .enUS)
        formatter.numberStyle = .currency
        formatter.allowsFloats = true
        formatter.alwaysShowsDecimalSeparator = true
        
        return formatter
    }()
    
    private static var storage: CurrencyFormatter?
    
    // MARK: Methods
    
    private init() {
        
        KnownSingletonTypes.add(CurrencyFormatter.self)
    }
    
    private func optionallyHardcodeCurrencySymbol(_ currencySymbol: inout String) {
        
        let replacements = [
            
            "KWD": "KD",
            "د.ك.‏": "د.ك"
        ]
        
        for (wrongValue, correctValue) in replacements where currencySymbol == wrongValue {
            
            currencySymbol = correctValue
            break
        }
    }
}

// MARK: - Singleton
extension CurrencyFormatter: Singleton {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static var shared: CurrencyFormatter {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = CurrencyFormatter()
        self.storage = instance
        
        return instance
    }
    
    internal static func destroyInstance() {
        
        self.storage = nil
    }
}
