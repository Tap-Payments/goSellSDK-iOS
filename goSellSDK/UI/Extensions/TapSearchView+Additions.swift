//
//  TapSearchView+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapSearchView.TapSearchView

internal extension TapSearchView {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal func setStyle(_ style: SearchBarStyle) {
		
		self.searchField.setTextStyle(style.text, style.placeholder)
	}
}
