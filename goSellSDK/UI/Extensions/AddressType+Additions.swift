//
//  AddressType+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

extension AddressType: Transformable {
    
    internal init?(untransformedValue: Any?) {
        
        if let stringValue = untransformedValue as? String {
            
            self.init(rawValue: stringValue.uppercased())
        }
        else if let addressType = untransformedValue as? AddressType {
            
            self.init(rawValue: addressType.rawValue)
        }
        else {
            
            return nil
        }
    }
}
