//
//  String+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension String {
	
	internal func tap_trimWhitespacesAndNewlines(nullifyIfResultIsEmpty: Bool = false) -> String? {
		
		let result = self.trimmingCharacters(in: .whitespacesAndNewlines)
		
		return (nullifyIfResultIsEmpty && result.tap_length == 0) ? nil : result
	}
}

// MARK: - Transformable
extension String: Transformable {
    
    internal init?(untransformedValue: Any?) {
        
        guard let stringValue = untransformedValue as? String else { return nil }
        self.init(stringValue)
    }
}
