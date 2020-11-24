//
//  CurrencyFormatter.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func TapSwiftFixesV2.synchronized

/// Currency Formatter utility class.
internal final class CurrencyFormatter {
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Formats amounted currency into readable string in specified locale.
    ///
    /// - Parameters:
    ///   - amountedCurrency: Amounted currency.
    ///   - locale: Locale.
    internal func format(_ amountedCurrency: AmountedCurrency, with locale: Locale = LocalizationManager.shared.selectedLocale, displayCurrency: Bool = true) -> String {
        
        let result: String = synchronized(self.currencyFormatter) {
            
            self.currencyFormatter.locale = locale
            self.currencyFormatter.currencyCode = amountedCurrency.currency.isoCode.uppercased()
            
            self.currencyFormatter.positiveFormat = nil
            self.currencyFormatter.negativeFormat = nil
            
            let positiveFormat: String? = self.currencyFormatter.positiveFormat
            let negativeFormat: String? = self.currencyFormatter.negativeFormat
            
            let currencySymbol: String = displayCurrency ? amountedCurrency.currencySymbol : .tap_empty
            
            self.currencyFormatter.locale = Locale.tap_enUS
            
            self.currencyFormatter.positiveFormat = positiveFormat
            self.currencyFormatter.negativeFormat = negativeFormat
            self.currencyFormatter.currencySymbol = currencySymbol
            
            let decimalAmount: NSDecimalNumber = amountedCurrency.amount as NSDecimalNumber
            
            if let amountString: String = self.currencyFormatter.string(from: decimalAmount) {
                
                return amountString
            }
            else {
                
                return currencySymbol + decimalAmount.stringValue
            }
        }
        
        return result
    }
    
    internal func localizedCurrencySymbol(for currencyCode: String, locale: Locale = .tap_enUS) -> String {
        
        var currencySymbol: String = (locale as NSLocale).displayName(forKey: .currencySymbol, value: currencyCode) ?? currencyCode
        self.optionallyHardcodeCurrencySymbol(&currencySymbol)
        
        return currencySymbol
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private lazy var currencyFormatter: NumberFormatter = {
        
        let formatter: NumberFormatter          = NumberFormatter(locale: .tap_enUS)
        formatter.numberStyle                   = .currency
        formatter.allowsFloats                  = true
        formatter.alwaysShowsDecimalSeparator   = true
        
        return formatter
    }()
    
    private static var storage: CurrencyFormatter?
    
    // MARK: Methods
    
    private init() {
        
        KnownStaticallyDestroyableTypes.add(CurrencyFormatter.self)
    }
    
    private func optionallyHardcodeCurrencySymbol(_ currencySymbol: inout String) {
        
        let replacements: [String: String] = [
            
            "KWD": "KD",
            "د.ك.‏": "د.ك"
        ]
        
        for (wrongValue, correctValue) in replacements where currencySymbol == wrongValue {
            
            currencySymbol = correctValue
            break
        }
    }
}

// MARK: - ImmediatelyDestroyable
extension CurrencyFormatter: ImmediatelyDestroyable {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static func destroyInstance() {
        
        self.storage = nil
    }
}

// MARK: - Singleton
extension CurrencyFormatter: Singleton {
    
    internal static var shared: CurrencyFormatter {
        
        if let nonnullStorage: CurrencyFormatter = self.storage {
            
            return nonnullStorage
        }
        
        let instance: CurrencyFormatter = CurrencyFormatter()
        self.storage = instance
        
        return instance
    }
    
    
}
