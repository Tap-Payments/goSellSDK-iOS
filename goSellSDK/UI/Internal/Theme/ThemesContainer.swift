//
//  ThemesContainer.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct ThemesContainer: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let themes: [Theme]
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case themes = "themes"
	}
}
