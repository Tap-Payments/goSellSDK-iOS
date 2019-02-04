//
//  KeyedDecodingContainer+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension KeyedDecodingContainer {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal func decodeURLIfPresent(for key: KeyedDecodingContainer.Key) -> URL? {
		
		guard self.contains(key) else { return nil }
		
		if let url = try? self.decode(URL.self, forKey: key) {
			
			return url
		}
		
		if let string = try? self.decode(String.self, forKey: key) {
			
			return URL(string: string)
		}
		
		return nil
	}
}
