//
//  Language.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	Foundation.NSLocale.Locale
import protocol	goSellSDK.CountableCasesEnum
import class	goSellSDK.goSellSDK

internal struct Language {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let localeIdentifier: String
}

// MARK: - CustomStringConvertible
extension Language: CustomStringConvertible {
	
	internal var description: String {
		
		let locale = Locale(identifier: self.localeIdentifier)
		return locale.localizedString(forLanguageCode: self.localeIdentifier)?.capitalized ?? self.localeIdentifier
	}
}

// MARK: - CountableCasesEnum
extension Language: CountableCasesEnum {
	
	internal static let all: [Language] = goSellSDK.availableLanguages.map { Language(localeIdentifier: $0) }
}

// MARK: - Encodable
extension Language: Encodable {
	
	internal func encode(to encoder: Encoder) throws {
	
		var container = encoder.singleValueContainer()
		try container.encode(self.localeIdentifier)
	}
}

// MARK: - Decodable
extension Language: Decodable {
	
	internal init(from decoder: Decoder) throws {
		
		var localeIdentifier: String
		
		do {
			
			let container = try decoder.singleValueContainer()
			localeIdentifier = try container.decode(String.self)
			
		}
		catch _ {
			
			localeIdentifier = Locale.LocaleIdentifier.en
		}
		
		self.init(localeIdentifier: localeIdentifier)
	}
}
