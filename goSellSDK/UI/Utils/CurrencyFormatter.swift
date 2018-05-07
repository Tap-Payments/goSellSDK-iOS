//
//  CurrencyFormatter.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import func TapSwiftFixes.synchronized

/// Currency Formatter utility class.
internal class CurrencyFormatter {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Shared instance.
    internal static let shared = CurrencyFormatter()
    
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
            
            var currencySymbol = String.empty
            if displayCurrency {
                
                currencySymbol = self.localizedCurrencySymbol(for: amountedCurrency.currency.isoCode, locale: locale)
            }
            
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
    
    // MARK: - Private -
    // MARK: Properties
    
    private lazy var currencyFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter(locale: .enUS)
        formatter.numberStyle = .currency
        formatter.allowsFloats = true
        formatter.alwaysShowsDecimalSeparator = true
        
        return formatter
    }()
    
    // MARK: Methods
    
    private init() {}
    
    private func localizedCurrencySymbol(for currencyCode: String, locale: Locale = .enUS) -> String {
        
        var currencySymbol = (locale as NSLocale).displayName(forKey: .currencySymbol, value: currencyCode) ?? currencyCode
        self.optionallyHardcodeCurrencySymbol(&currencySymbol)
        
        return currencySymbol
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
