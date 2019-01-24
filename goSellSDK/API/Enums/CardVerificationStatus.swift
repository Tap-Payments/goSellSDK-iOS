//
//  CardVerificationStatus.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal enum CardVerificationStatus: String, Decodable {
	
	case initiated	= "INITIATED"
	case valid		= "VALID"
	case invalid	= "INVALID"
}
