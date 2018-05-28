//
//  InternalError.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum InternalError: Int {
    
    case invalidCountryCode = 1
    case invalidAmountModificatorType
    case invalidCurrency
    case invalidCustomerInfo
    case invalidEmail
    case invalidUnitOfMeasurement
    case invalidMeasurement
}
