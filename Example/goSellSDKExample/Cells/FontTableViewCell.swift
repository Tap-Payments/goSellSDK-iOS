//
//  FontTableViewCell.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIFont.UIFont

internal class FontTableViewCell: TitleTableViewCell {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal func setFont(_ font: String) {
		
		let uiFont = UIFont(name: font, size: 17.0)!
		self.setTitle(uiFont.familyName)
		
		self.titleTextLabel?.font = uiFont
	}
}
