//
//  AcceptedCardType.swift
//  goSellSDK
//
//  Created by Osama Rabie on 19/02/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
/// Card Types the merchanty will use to define what types of cards he wants his clients to use
@objc public class CardType:NSObject {
	
    
    @objc var cardType:cardTypes = .Unknown
    
    @objc public enum cardTypes:Int
    {
        case Credit
        case Debit
        case Unknown
    }
    
      init(cardType:String) {
        if cardType.lowercased() == "credit"
        {
            self.cardType = .Credit
        }else if cardType.lowercased() == "debit"
        {
            self.cardType = .Debit
        }
        self.cardType = .Unknown
    }
    
    @objc public init(cardType:cardTypes) {
           self.cardType = cardType
       }
}
