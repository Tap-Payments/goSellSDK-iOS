//
//  CardScheme.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import enum TapCardValidator.CardBrand

internal enum CardScheme: String, Decodable {
    
    case knet               = "KNET"
    case visa               = "VISA"
    case masterCard         = "MASTERCARD"
    case americanExpress    = "AMERICAN_EXPRESS"
    case mada               = "MADA"
    case benefit            = "BENEFIT"
    case sadadAccount       = "SADAD_ACCOUNT"
    case fawry              = "FAWRY"
    case naps               = "NAPS"
    case omanNet            = "OMAN_NET"
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var cardBrand: CardBrand {
        
        switch self {
            
        case .knet: return .knet
        case .visa: return .visa
        case .masterCard: return .masterCard
        case .americanExpress: return .americanExpress
        case .mada: return .mada
        case .benefit: return .benefit
        case .sadadAccount: return .sadad
        case .fawry: return .fawry
        case .naps: return .naps
        case .omanNet: return .omanNet

        }
    }
}
