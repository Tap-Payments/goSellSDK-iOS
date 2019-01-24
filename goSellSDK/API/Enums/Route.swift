//
//  Route.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Route enum.
internal enum Route: String {
    
    case authorize                  = "authorize/"
    case billingAddress             = "billing_address/"
    case bin                        = "bin/"
    case card                       = "card/"
	case cardVerification			= "card/verify/"
    case charges                    = "charges/"
	case customers					= "customers/"
    case initialization             = "init"
    case paymentOptions             = "payment/types/"
    case token                      = "token/"
    case tokens                     = "tokens/"
    
    internal var decoder: JSONDecoder {
        
        let decoder = JSONDecoder()
        
        switch self {
            
        case .charges, .authorize, .cardVerification:
            
            decoder.dateDecodingStrategy = .custom { (aDecoder) -> Date in
                
                let container = try aDecoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                let double = NumberFormatter().number(from: dateString)?.doubleValue ?? 0.0
                return Date(timeIntervalSince1970: double / 1000.0)
            }
            
        case .token, .tokens:
            
            decoder.dateDecodingStrategy = .secondsSince1970
            
        default:
            
            break
        }
        
        return decoder
    }
}
