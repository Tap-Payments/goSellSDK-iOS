//
//  EditableTextInsetsTextField.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	EditableTextInsetsTextField.EditableTextInsetsTextField
import enum 	EditableTextInsetsTextField.TextFieldClearButtonPosition

internal extension EditableTextInsetsTextField {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var localizedClearButtonPosition: TextFieldClearButtonPosition {
		
		get {
			
			return self.clearButtonPosition
		}
		set {
			
			let ltr = LocalizationProvider.shared.layoutDirection == .leftToRight
			
			switch newValue {
				
			case .left:		self.clearButtonPosition = ltr ? .left 	: .right
			case .right:	self.clearButtonPosition = ltr ? .right	: .left

			}
		}
	}
}
