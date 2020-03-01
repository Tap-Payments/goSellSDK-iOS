//
//  cardType.swift
//  goSellSDK
//
//  Created by Osama Rabie on 01/03/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//


/// Enum defining SDK mode.
@objc public enum cardTypes: Int, CaseIterable {
    
    @objc(Credit)       case Credit
    @objc(Debit)        case Debit
    @objc(All)          case All
}

// MARK: - CustomStringConvertible
extension cardTypes: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            case .Credit:         return "Credit"
            case .Debit:          return "Debit"
            case .All:            return "All"
        }
    }
}

