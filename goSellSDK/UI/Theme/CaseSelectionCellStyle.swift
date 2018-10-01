//
//  CaseSelectionCellStyle.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal struct CaseSelectionCellStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let title: TextStyle
	
	internal let value: TextStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case title = "title_style"
		case value = "value_style"
	}
}
