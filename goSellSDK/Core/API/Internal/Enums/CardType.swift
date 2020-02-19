//
//  AcceptedCardType.swift
//  goSellSDK
//
//  Created by Osama Rabie on 19/02/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
/// Card Types the merchanty will use to define what types of cards he wants his clients to use
@objc internal enum CardType: Int {
	
	case Credit = 0
	case Debit = 1
    case Unknown = 2
}

extension CardType
{
    internal static func mapToType(stringCardType:String) -> CardType
    {
        if stringCardType.lowercased() == "credit"
        {
            return Credit
        }else if stringCardType.lowercased() == "debit"
        {
            return Debit
        }
        return Unknown
    }
}
