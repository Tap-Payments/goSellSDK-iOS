//
//  PaymentOption+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension PaymentOption {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var sourceIdentifier: SourceIdentifier {
        
        guard self.paymentType == .web else {
            
            fatalError("sourceIdentifier should not be called on non-web payment type.")
        }
        
        switch self.brand {
            
        case .knet:
            
            return .KNET
            
        case .benefit:
            
            return .BENEFIT
            
        case .sadad:
            
            return .SADAD
            
        case .fawry:
            
            return .FAWRY
            
        default:
            
            fatalError("Payment option \(self) is not supported.")
        }
    }
}
