//
//  AcceptedCardType.swift
//  goSellSDK
//
//  Created by Osama Rabie on 19/02/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
/// Card Types the merchanty will use to define what types of cards he wants his clients to use
@objcMembers public class CardType:NSObject {
	
    
    var cardType:cardTypes = .All
    
      public init(cardTypeString:String) {
        if cardTypeString.lowercased() == "credit"
        {
            self.cardType = .Credit
        }else if cardTypeString.lowercased() == "debit"
        {
            self.cardType = .Debit
        }else
        {
            self.cardType = .All
        }
    }
    
    public init(cardType:cardTypes) {
           self.cardType = cardType
       }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let other = object as? CardType {
            return self.cardType == other.cardType
        } else {
            return false
        }
    }
}




