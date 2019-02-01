//
//  ColorTableViewCell.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIView.UIView

internal final class ColorTableViewCell: TitleTableViewCell {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal func setColor(_ color: Color) {
		
		self.setTitle(color.description)
		
		self.colorView?.backgroundColor = color.asUIColor
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	@IBOutlet private weak var colorView: UIView?
}
