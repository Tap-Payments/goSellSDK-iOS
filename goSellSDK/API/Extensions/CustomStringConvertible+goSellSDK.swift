//
//  CustomStringConvertible+goSellSDK.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension CustomStringConvertible {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal func description(with extraSpaces: Int) -> String {
        
        let spaces = String(repeating: CustomStringConvertibleConstants.spaceString, count: extraSpaces)
        let separator = CustomStringConvertibleConstants.newlineString.appending(spaces)
        let originalDescription = self.description
        
        let newLineTabulation = CustomStringConvertibleConstants.newlineString.appending(CustomStringConvertibleConstants.tabulationString)
        
        if originalDescription.hasPrefix(CustomStringConvertibleConstants.newlineString) {
            
            let suffix = originalDescription.dropFirst(CustomStringConvertibleConstants.newlineString.length)
            let suffixString = String(suffix)
            
            let desc = newLineTabulation.appending(suffixString)
            return desc.replacingOccurrences(of: newLineTabulation, with: separator)
        }
        else {
            
            return originalDescription.replacingOccurrences(of: newLineTabulation, with: separator)
        }
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    
}

private struct CustomStringConvertibleConstants {
    
    fileprivate static let spaceString      = " "
    
    fileprivate static let newlineString    = "\n"
    fileprivate static let newline          = Character(CustomStringConvertibleConstants.newlineString)
    
    fileprivate static let tabulationString = "\t"
    
    
    @available(*, unavailable) private init() {}
}
