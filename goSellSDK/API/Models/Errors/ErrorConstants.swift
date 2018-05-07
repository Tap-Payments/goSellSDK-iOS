//
//  ErrorConstants.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct ErrorConstants {
    
    internal static let internalErrorDomain = "company.tap.gosellsdk"
    
    internal struct UserInfoKeys {
        
        internal static let currencyCode = "currency_code"
        internal static let emailAddress = "email_address"
        internal static let unitOfMeasurement = "unit_of_measurement"
        
        @available(*, unavailable) private init() {}
    }
    
    @available(*, unavailable) private init() {}
}
