//
//  EditableTextInsetsTextFieldV2.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	EditableTextInsetsTextFieldV2.EditableTextInsetsTextField

internal extension EditableTextInsetsTextField {
	
	// MARK: - Internal -
	// MARK: Properties
	
	var localizedClearButtonPosition: EditableTextInsetsTextField.ClearButtonPosition {
		
		get {
			
			return self.clearButtonPosition
		}
		set {
			
			let ltr = LocalizationManager.shared.layoutDirection == .leftToRight
			
			var desiredPosition: EditableTextInsetsTextField.ClearButtonPosition
			
			switch newValue {
				
			case .left:		desiredPosition = ltr ? .left 	: .right
			case .right:	desiredPosition = ltr ? .right	: .left
				
			}
			
			self.clearButtonPosition = desiredPosition
		}
	}
}
