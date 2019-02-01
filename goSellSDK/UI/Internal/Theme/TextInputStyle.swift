//
//  TextInputStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct TextInputStyle: Decodable {
	
	// MARK: - Internal -
	
	internal enum InputSituation {
		
		case valid
		case invalid
		case placeholder
	}
	
	// MARK: Properties
	
	internal subscript(_ situation: InputSituation) -> TextStyle {
		
		get {
			
			switch situation {
				
			case .valid:		return self.valid
			case .invalid:		return self.invalid
			case .placeholder:	return self.placeholder
				
			}
		}
		set {
			
			switch situation {
				
			case .valid:		self.valid = newValue
			case .invalid:		self.invalid = newValue
			case .placeholder:	self.placeholder = newValue

			}
		}
	}
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case valid 			= "valid"
		case invalid 		= "invalid"
		case placeholder	= "placeholder"
	}
	
	// MARK: Properties
	
	private var valid: TextStyle
	
	private var invalid: TextStyle
	
	private var placeholder: TextStyle
}
