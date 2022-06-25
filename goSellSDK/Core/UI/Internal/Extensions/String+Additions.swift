//
//  String+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

// MARK: - Transformable
extension String: Transformable {
    
    internal init?(untransformedValue: Any?) {
        
        guard let stringValue = untransformedValue as? String else { return nil }
        self.init(stringValue)
    }
    
    internal func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
