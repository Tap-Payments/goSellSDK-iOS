//
//  TapSearchView+Additions.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class TapSearchViewV2.TapSearchView

internal extension TapSearchView {
	
	// MARK: - Internal -
	// MARK: Methods
	
	func setStyle(_ style: SearchBarStyle) {
		self.searchField.setTextStyle(style.text, style.placeholder)
        self.searchHolderBackgroundColor = style.searchHolderBackgroundColor.color
	}
    
    func setBackGround(_ color: UIColor) {
        self.backgroundColor = color
    }
}
