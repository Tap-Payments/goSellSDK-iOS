//
//  Route.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Route enum.
internal enum Route: String {
    
    case initialization = "init"
    case charges = "charges/"
    case token = "token/"
    case paymentOptions = "payment/types/"
    
    internal var decoder: JSONDecoder {
        
        let decoder = JSONDecoder()
        
        switch self {
            
        case .charges:
            
            decoder.dateDecodingStrategy = .custom { (aDecoder) -> Date in
                
                let container = try aDecoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                let double = NumberFormatter().number(from: dateString)?.doubleValue ?? 0.0
                return Date(timeIntervalSince1970: double / 1000.0)
            }
            
        case .token:
            
            decoder.dateDecodingStrategy = .secondsSince1970
            
        default:
            
            break
        }
        
        return decoder
    }
}
