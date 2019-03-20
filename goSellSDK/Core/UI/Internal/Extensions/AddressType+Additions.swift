//
//  AddressType+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

extension AddressType: Transformable {
    
    internal init?(untransformedValue: Any?) {
        
        if let stringValue = untransformedValue as? String {
			
			try? self.init(string: stringValue)
        }
        else if let addressType = untransformedValue as? AddressType {
            
            self.init(rawValue: addressType.rawValue)
        }
        else {
            
            return nil
        }
    }
}
