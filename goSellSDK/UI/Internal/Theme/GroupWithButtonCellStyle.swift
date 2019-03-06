//
//  GroupWithButtonCellStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct GroupWithButtonCellStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let titleStyle: TextStyle
	
	internal let buttonTitleStyle: TextStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case titleStyle			= "title_style"
		case buttonTitleStyle	= "button_title_style"
	}
}
