//
//  String+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

extension String: Transformable {
    
    internal init?(untransformedValue: Any?) {
        
        guard let stringValue = untransformedValue as? String else { return nil }
        self.init(stringValue)
    }
}
