//
//  InternalError.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal enum InternalError: Int {
	
	case invalidCountryCode = 1
	case invalidAddressType
	case invalidAmountModificatorType
	case invalidAuthorizeActionType
	case invalidCurrency
	case invalidCustomerInfo
	case invalidTokenType
	case customerAlreadyExists
	case cardAlreadyExists
	case invalidEmail
	case invalidISDNumber
	case invalidPhoneNumber
	case invalidUnitOfMeasurement
	case invalidMeasurement
	case invalidEnumValue
	case noMerchantData
}
