//
//  GroupCellStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct GroupCellStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let titleStyle: TextStyle
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case titleStyle = "title_style"
	}
}
