//
//  ErrorConstants.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct ErrorConstants {
    
    internal static let internalErrorDomain = "company.tap.gosellsdk"
    
    internal struct UserInfoKeys {
        
        internal static let amountModificatorType   = "amount_modificator_type"
        internal static let authorizeActionType     = "authorize_action_type"
        internal static let countryCode             = "country_code"
        internal static let currencyCode            = "currency_code"
        internal static let customerInfo            = "customer_info"
        internal static let emailAddress            = "email_address"
        internal static let isdNumber               = "isd_number"
        internal static let measurementCategory     = "measurement_category"
        internal static let measurementUnit         = "measurement_unit"
        internal static let phoneNumber             = "phone_number"
        internal static let unitOfMeasurement       = "unit_of_measurement"
        
        @available(*, unavailable) private init() {}
    }
    
    @available(*, unavailable) private init() {}
}
