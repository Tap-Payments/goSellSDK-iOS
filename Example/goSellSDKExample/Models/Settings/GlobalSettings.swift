//
//  GlobalSettings.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	Foundation.NSLocale.Locale

internal struct GlobalSettings: Encodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal static let `default` = GlobalSettings(sdkLanguage: Language(localeIdentifier: Locale.TapLocaleIdentifier.en))
	
	internal var sdkLanguage: Language
	
	// MARK: Methods
	
	internal init(sdkLanguage: Language) {
		
		self.sdkLanguage = sdkLanguage
	}
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case sdkLanguage	= "sdk_language"
	}
}

// MARK: - Decodable
extension GlobalSettings: Decodable {
	
	internal init(from decoder: Decoder) throws {
		
		let container	= try decoder.container(keyedBy: CodingKeys.self)
		let sdkLanguage	= try container.decodeIfPresent	(Language.self,	forKey: .sdkLanguage)	?? GlobalSettings.default.sdkLanguage
		
		self.init(sdkLanguage: sdkLanguage)
	}
}
