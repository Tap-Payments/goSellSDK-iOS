//
//  PaymentStatus.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal enum PaymentStatus {
    
    case cancelled
    case successfulCharge(Charge)
    case successfulAuthorize(Authorize)
	case successfulCardSave(CardVerification)
	case successfulCardTokenize(Token, Bool)
    case chargeFailure(Charge?, TapSDKError?)
    case authorizationFailure(Authorize?, TapSDKError?)
	case cardSaveFailure(CardVerification?, TapSDKError?)
	case cardTokenizeFailure(TapSDKError)
}
