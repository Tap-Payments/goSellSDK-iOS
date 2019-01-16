//
//  EditableTextInsetsTextField.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	EditableTextInsetsTextField.EditableTextInsetsTextField

internal extension EditableTextInsetsTextField {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var localizedClearButtonPosition: EditableTextInsetsTextField.ClearButtonPosition {
		
		get {
			
			return self.clearButtonPosition
		}
		set {
			
			let ltr = LocalizationProvider.shared.layoutDirection == .leftToRight
			
			var desiredPosition: EditableTextInsetsTextField.ClearButtonPosition
			
			switch newValue {
				
			case .left:		desiredPosition = ltr ? .left 	: .right
			case .right:	desiredPosition = ltr ? .right	: .left
				
			}
			
			self.clearButtonPosition = desiredPosition
		}
	}
}
