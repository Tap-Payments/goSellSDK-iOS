//
//  Decodable+Additions.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation

internal extension Decodable {
    
    // MARK: - Internal -
    // MARK: Methods
    
    init?(dictionaryRepresentation: [String: Any]) {
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: []) else { return nil }
		
		do {
			
			self = try JSONDecoder().decode(Self.self, from: jsonData)
		}
		catch let error {
			
			print("Error retrieving settings: \(error)")
			return nil
		}
    }
}
