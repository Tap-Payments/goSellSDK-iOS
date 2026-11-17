//
//  KeyboardAppearance.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import UIKit
import enum UIKit.UITextInputTraits.UIKeyboardAppearance

internal enum KeyboardAppearance: String, Decodable {
	
	case light = "light"
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var uiKeyboardAppearance: UIKeyboardAppearance {
		
		switch self {
			
		case .light: return .light
		}
	}
}
