//
//  CaseSelectionCellStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct CaseSelectionCellStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let title: TextStyle
	
	internal let value: TextStyle
	
	internal let separator: AppearanceStyle<HexColor>
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case title		= "title_style"
		case value		= "value_style"
		case separator	= "separator_color"
	}
}
