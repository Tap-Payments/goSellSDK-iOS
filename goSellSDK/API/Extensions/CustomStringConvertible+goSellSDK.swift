//
//  CustomStringConvertible+goSellSDK.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension CustomStringConvertible {
    
    // MARK: Methods
    
    internal func description(with extraSpaces: Int) -> String {
        
        let separator = "\n\(String(repeatElement(" ", count: extraSpaces)))"
        let originalDescription = self.description
        
        var desc: String
        if originalDescription.hasPrefix("\n") {
            
            let index = originalDescription.index(after: originalDescription.index(of: "\n")!)
            desc = "\n\t" + String(originalDescription.suffix(from: index))
        }
        else {
            
            desc = originalDescription
        }
        
        return desc.replacingOccurrences(of: "\n\t", with: separator)
    }
}
